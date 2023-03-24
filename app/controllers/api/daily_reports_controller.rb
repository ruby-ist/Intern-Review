class Api::DailyReportsController < Api::ApiController
	before_action :doorkeeper_authorize!
	before_action :set_daily_report, only: [:update, :destroy]

	def index
		request.variant = user_sym
		@user = current_account.accountable

		if current_account.intern?
			render json: {error: "Your account doesn't have that privilege"}, status: :non_authoritative_information
			return
		end

		@type = "all"
		if params['date'] == "all"
			@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id)
		elsif params['date']
			begin
				@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id).where(date: params['date'].to_date)
			rescue
				@daily_reports = DailyReport.none
			end
		else
			@type = "today"
			@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id).where(date: Date.today)
		end
	end

	def create
		@section = Section.find params[:section_id]
		@section_report = SectionReport.find_or_create_by(intern: current_user, section: @section)
		@daily_report = @section_report.daily_reports.build(daily_report_params)

		if @section_report.daily_reports.count == 0
			@section_report.start_date = @daily_report.date
		end

		if @daily_report.completed?
			@section_report.end_date = @daily_report.date
			@section_report.completed!
		end

		if @daily_report.save && @section_report.save
			render partial: "api/daily_reports/daily_report", locals: {daily_report: @daily_report}, status: :created
		else
			@daily_reports = @section.daily_reports.order(date: :desc)
			render json: {errors: @daily_report.errors}, status: :unprocessable_entity
		end
	end

	def update
		if @daily_report.update(daily_report_params)

			if @daily_reports.first == @daily_report
				if @daily_report.ongoing?
					@section_report.end_date = nil
					@section_report.ongoing!
				elsif @daily_report.completed?
					@section_report.end_date = @daily_report.date
					@section_report.completed!
				end
				@section_report.save!
			end

			render partial: "api/daily_reports/daily_report", locals: {daily_report: @daily_report}, status: :ok
		else
			render json: {errors: @daily_report.errors}, status: :unprocessable_entity
		end
	end

	def destroy
		if @daily_reports.first == @daily_report
			if @daily_report.completed?
				@section_report.end_date = nil
				@section_report.ongoing!
			end
		end

		if @section_report.daily_reports.count == 1
			@section_report.start_date = nil
			@section_report.ongoing!
		end

		if @daily_report.destroy!
			@section_report.save!
		end

		head :no_content
	end

	def feedback
		@section = Section.find @daily_report.section_id
	end

	private

	def set_daily_report
		@daily_report = DailyReport.find params[:id]
		@section_report = @daily_report.section_report
		@daily_reports = @section_report.daily_reports.order(date: :desc, created_at: :desc).limit(1)
	rescue
		render json: { error: "Daily report not found!" }, status: :not_found
	end

	def daily_report_params
		params.require(:daily_report).permit(:date, :progress, :status)
	end

	def user_sym
		current_account.accountable_type.underscore.to_sym
	end

end
