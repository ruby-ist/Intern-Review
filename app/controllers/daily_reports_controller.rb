class DailyReportsController < ApplicationController
	before_action :authenticate_account!
	before_action :not_an_intern_account!, only: [:edit_feedback, :update_feedback]
	before_action :set_daily_report, except: [:index, :create, :edit_feedback, :destroy]

	def index
		request.variant = user_sym
		@user = current_account.accountable

		if current_account.intern?
			redirect_to account_path(current_account), alert: "You can't do that"
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
			redirect_to @section, notice: "Report successfully created!"
		else
			@daily_reports = @section.daily_reports.order_by_date
			render "sections/show", status: :unprocessable_entity
		end
	end

	def edit
		render "sections/show"
	end

	def update
		if @daily_report.update(daily_report_params)
			redirect_to @section, notice: "Report has been edited successfully"
		else
			render 'sections/show', status: :unprocessable_entity
		end
	end

	def destroy
		daily_report = DailyReport.find params[:id]
		daily_report.destroy!
		redirect_to section_path(daily_report.section), notice: "Report has been destroyed"
	end

	def edit_feedback
		@daily_report = DailyReport.find params[:id]
		respond_to do |format|
			format.turbo_stream do
				render turbo_stream: turbo_stream.replace( @daily_report,
														   partial: 'daily_reports/daily_report',
														   locals: { daily_report: @daily_report, feedback: true } )
			end
			format.html
		end
	end

	def update_feedback
		daily_report = DailyReport.find params[:id]
		respond_to do |format|
			if daily_report.update(feedback_param)
				format.turbo_stream do
					render turbo_stream: turbo_stream.replace(daily_report)
				end
				format.html { redirect_to section_path(daily_report.section, notice: "Feedback has been added") }
			else
				format.turbo_stream do
					render turbo_stream: turbo_stream.update("daily_report_#{daily_report.id}_form",
															 partial: "daily_reports/feedback_form",
															 locals: { daily_report: daily_report })
				end
				format.html { redirect_back fallback_location: section_path(daily_report.section) }
			end
		end
	end

	private

	def set_daily_report
		@daily_report = DailyReport.find params[:id]
		@section_report = @daily_report.section_report
		@section = @section_report.section
		@daily_reports = @section_report.daily_reports.order_by_date
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
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
end
