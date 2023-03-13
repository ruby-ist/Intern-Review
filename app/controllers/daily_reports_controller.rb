class DailyReportsController < ApplicationController

	before_action :set_daily_report, except: [:create, :destroy]

	def create
		@section = Section.find params[:section_id]
		@daily_report = DailyReport.new(daily_report_params)
		@daily_report.section_id = @section.id
		@daily_report.course_id = @section.course_id
		respond_to do |format|
			if @daily_report.save
				format.html { redirect_to @section }
			else
				@daily_reports = DailyReport.where(section_id: @section.id).order(created_at: :desc)
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

	private

	def set_daily_report
		@daily_report = DailyReport.find params[:id]
		@section = Section.find @daily_report.section_id
		@daily_reports = DailyReport.where(section_id: @daily_report.section_id)
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def daily_report_params
		params.require(:daily_report).permit(:date, :progress, :status)
	end
end
