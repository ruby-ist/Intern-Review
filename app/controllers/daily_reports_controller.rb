class DailyReportsController < ApplicationController
	before_action :authenticate_account!
	before_action :set_daily_report, only: [:edit, :update]

	def index
		request.variant = user_sym
		@user = current_account.accountable

		if current_account.intern?
			redirect_to account_path(current_account), status: :non_authoritative_information
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
		elsif @daily_report.completed?
			@section_report.end_date = @daily_report.date
			@section_report.completed!
		end

		if @daily_report.save && @section_report.save
			redirect_to @section, notice: "Report successfully created!"
		else
			@daily_reports = @section.daily_reports.order(date: :desc)
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
		@daily_report = DailyReport.find params[:id]
		@daily_report.destroy!
		redirect_to section_path(@daily_report.section_id), notice: "Report has been destroyed"
	end

	def feedback
		@daily_report = DailyReport.find params[:id]
		@section = Section.find @daily_report.section_id
	end

	private

	def set_daily_report
		@daily_report = DailyReport.find params[:id]
		@section_report = @daily_report.section_report
		@section = @section_report.section
		@daily_reports = @section.daily_reports.order(date: :desc)
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def daily_report_params
		params.require(:daily_report).permit(:date, :progress, :status)
	end

	def user_sym
		current_account.accountable_type.underscore.to_sym
	end
end
