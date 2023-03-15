class SectionsController < ApplicationController

	before_action :account_is_not_an_intern!, except: :show
	before_action :authenticate_account!, only: :show
	before_action :set_course, only: %w{ new create }
	before_action :set_section, only: %w{ show edit update destroy }

	def new
		@section = Section.new
	end

	def create
		@section = @course.sections.build(section_params)
		respond_to do |format|
			if @section.save
				format.html{ redirect_to @course }
			else
				format.html{ render :new, status: :unprocessable_entity}
			end
		end
	end

	def show
		@reference = Reference.new
		if current_account.intern?
			@section_report = SectionReport.find_or_create_by(intern: current_user, section: @section)
			@daily_report = @section_report.daily_reports.build
			@daily_reports = @section_report.daily_reports.order(date: :desc)
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @section.update(section_params)
				format.html{ redirect_to course_path(@section.course_id) }
			else
				format.html{ render :edit, status: :unprocessable_entity}
			end
		end
	end

	def destroy
		@section.destroy!
		redirect_to course_path(@section.course_id)
	end

	private

	def set_course
		@course = Course.find params[:course_id]
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def set_section
		@section = Section.find params[:id]
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def section_params
		params.require(:section).permit(:title, :context, :days_required)
	end

end