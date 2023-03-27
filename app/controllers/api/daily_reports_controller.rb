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

		if @daily_report.save
			render partial: "api/daily_reports/daily_report", locals: {daily_report: @daily_report}, status: :created
		else
			render json: {errors: @daily_report.errors}, status: :unprocessable_entity
		end
	end

	def update
		if @daily_report.update(daily_report_params)
			render partial: "api/daily_reports/daily_report", locals: {daily_report: @daily_report}, status: :ok
		else
			render json: {errors: @daily_report.errors}, status: :unprocessable_entity
		end
	end

	def destroy
		@daily_report.destroy!
		head :no_content
	end

	def feedback
		@section = Section.find @daily_report.section_id
	end

	private

	def set_daily_report
		@daily_report = DailyReport.find params[:id]
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
