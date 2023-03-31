class SectionsController < ApplicationController
	before_action :not_an_intern_account!, except: :show
	before_action :authenticate_account!, only: :show
	before_action :set_course, only: %w{ new create }
	before_action :set_section, only: %w{ show edit update destroy }

	def new
		@section = Section.new
	end

	def create
		@section = @course.sections.build(section_params)
		if @section.save
			redirect_to @course, notice: "A new section has been added!"
		else
			render :new, status: :unprocessable_entity
		end
	end

	def show
		@reference = Reference.new
		@section_report = nil
		if current_account.intern?
			@section_report = SectionReport.find_or_create_by!(intern: current_user, section: @section)
			@daily_report = @section_report.daily_reports.build
			@daily_reports = @section_report.daily_reports.order_by_date.includes(intern: :account)
		elsif current_account.trainer?
			@daily_reports = DailyReport.for_trainer(current_user.id).where(section_reports: { section_id: @section.id })
		elsif current_account.admin_user?
			@daily_reports = DailyReport.for_admin_user(current_user.id).where(section_reports: { section_id: @section.id })
		end
	end

	def edit
	end

	def update
		if @section.update(section_params)
			redirect_to course_path(@section.course_id), notice: "Section has been edited successfully!"
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		@section.destroy!
		redirect_to course_path(@section.course_id), notice: "Section has been removed from the course"
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

	def enrolled?
		if current_account.intern?
			unless current_user.course_ids.include? @section.course_id
				redirect_back fallback_location: account_path(current_account), alert: "You are not enrolled on that course"
			end
		end
	end
end