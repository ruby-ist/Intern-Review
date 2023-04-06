class Api::DailyReportsController < Api::ApiController
	before_action :doorkeeper_authorize!
	before_action :intern_account!, except: [:index, :update_feedback]
	before_action :not_an_intern_account!, only: [:update_feedback]
	before_action :set_daily_report, only: [:update, :destroy, :update_feedback]
	before_action :set_section, only: :create
	before_action :associated_report, only: [:update, :destroy]

	def index
		request.variant = user_sym
		@user = current_account.accountable

		if current_account.intern?
			render json: {errors: { account: "Your account doesn't have that privilege"}}, status: :forbidden
			return
		end

		page = params[:page].to_i
		@type = "all"
		if params['date'] == "all"
			@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id).page(page)
		elsif params['date']
			begin
				@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id).where(date: params['date'].to_date).page(page)
			rescue
				@daily_reports = DailyReport.none
			end
		else
			@type = "today"
			@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id).where(date: Date.today).page(page)
		end
	end

	def create
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

	def update_feedback
		if @daily_report.update(feedback_param)
			render partial: "api/daily_reports/daily_report", locals: {daily_report: @daily_report}, status: :ok
		else
			render json: {errors: @daily_report.errors}, status: :unprocessable_entity
		end
	end

	private

	def set_section
		@section = Section.find_by_id! params[:section_id].to_i
	rescue
		render json: { error: "Section not found!" }, status: :not_found
	end

	def set_daily_report
		@daily_report = DailyReport.find_by_id params[:id].to_i
	rescue
		render json: { error: "Daily report not found!" }, status: :not_found
	end

	def daily_report_params
		params.require(:daily_report).permit(:date, :progress, :status)
	end

	def feedback_param
		params.require(:daily_report).permit(:feedback)
	end

	def user_sym
		current_account.accountable_type.underscore.to_sym
	end

	def associated_report
		unless @daily_report.section_report.intern_id == current_user.id
			render json: {errors: { intern: "You're don't have access to that record"}}, status: :forbidden
		end
	end
end
