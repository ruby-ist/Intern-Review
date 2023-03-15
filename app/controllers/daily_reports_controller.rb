class DailyReportsController < ApplicationController


	before_action :set_daily_report, only: [:edit, :update]

	def create
		@section = Section.find params[:section_id]
		@section_report = SectionReport.find_or_create_by(intern: current_user, section: @section)
		@daily_report = @section_report.daily_reports.build(daily_report_params)

		if @section_report.daily_reports.count == 0
			@section_report.start_date = @daily_report.date
		elsif @daily_report.completed?
			@section_report.end_date = @daily_report.date
		end

		respond_to do |format|
			if @daily_report.save && @section_report.save
				format.html { redirect_to @section }
			else
				@daily_reports = @section.daily_reports.order(date: :desc)
				format.html { render "sections/show", status: :unprocessable_entity }
			end
		end
	end

	def edit
		render "sections/show"
	end

	def update
		respond_to do |format|
			if @daily_report.update(daily_report_params)
				format.html{ redirect_to @section }
			else
				format.html { render 'sections/show', status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@daily_report = DailyReport.find params[:id]
		@daily_report.destroy!
		redirect_to section_path(@daily_report.section_id)
	end

	def feedback
		@daily_report = DailyReport.find params[:id]
		@section = Section.find @daily_report.section_id
	end

	private

	def set_daily_report
		@daily_report = DailyReport.find params[:id]
		@section = Section.find @daily_report.section_report.section_id
		@daily_reports = @section.daily_reports.order(date: :desc)
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def daily_report_params
		params.require(:daily_report).permit(:date, :progress, :status)
	end
end