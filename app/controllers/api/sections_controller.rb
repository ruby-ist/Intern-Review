class Api::SectionsController < Api::ApiController

	before_action :doorkeeper_authorize!
	before_action :not_an_intern_account!, except: :show
	before_action :set_course, only: :create
	before_action :set_section, only: %w{ show update destroy }
	before_action :enrolled?, only: :show

	def create
		@section = @course.sections.build(section_params)
		if @section.save
			render partial: 'api/sections/section', locals: {section: @section}, status: :created
		else
			render json: {errors: @section.errors}, status: :unprocessable_entity
		end
	end

	def show
		@section_report = nil
		if current_account.intern?
			@section_report = SectionReport.find_or_create_by(intern: current_user, section: @section)
			@daily_reports = @section_report.daily_reports.order_by_date
		elsif current_account.trainer?
			@daily_reports = DailyReport.for_trainer(current_user.id).where(section_reports: { section_id: @section.id })
		elsif current_account.admin_user?
			@daily_reports = DailyReport.for_admin_user(current_user.id).where(section_reports: { section_id: @section.id })
		end
	end

	def update
		if @section.update(section_params)
			render partial: 'api/sections/section', locals: {section: @section}, status: :ok
		else
			render json: {errors: @section.errors}, status: :unprocessable_entity
		end
	end

	def destroy
		@section.destroy!
		head :no_content
	end

	private

	def set_course
		@course = Course.find params[:course_id]
	rescue
		render json: {error: "Course not found!"}, status: :not_found
	end

	def set_section
		@section = Section.find params[:id]
	rescue
		render json: {error: "Section not found!"}, status: :not_found
	end

	def section_params
		params.require(:section).permit(:title, :context, :days_required)
	end

	def enrolled?
		if current_account.intern?
			unless current_user.course_ids.include? @section.course_id
				render json: {errors: {intern: "not enrolled for the course" }}, status: :non_authoritative_information
				return
			end
		end
	end

end
