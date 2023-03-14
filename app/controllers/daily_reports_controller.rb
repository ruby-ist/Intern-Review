class DailyReportsController < ApplicationController

	before_action :set_daily_report, only: [:edit, :update]

	def create
		@section = Section.find params[:section_id]
		@daily_report = DailyReport.new(daily_report_params)
		@section_report = SectionReport.find_or_create_by(intern_id: 1, section_id: params[:section_id])
		@section_report.daily_reports << @daily_report
		respond_to do |format|
			if @daily_report.save
				format.html { redirect_to @section }
			else
				@daily_reports = @section.daily_reports
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
		@daily_reports = @section.daily_reports
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def daily_report_params
		params.require(:daily_report).permit(:date, :progress, :status)
	end
end
