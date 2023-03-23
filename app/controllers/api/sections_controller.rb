class Api::SectionsController < Api::ApiController

	before_action :not_an_intern_account!, except: :show
	before_action :doorkeeper_authorize!, only: :show
	before_action :set_course, only: %w{ new create }
	before_action :set_section, only: %w{ show edit update destroy }

	def create
		@section = @course.sections.build(section_params)
		if @section.save
			render json: @section, status: :created
		else
			render json: @section.errors, status: :unprocessable_entity
		end
	end

	def show
		@reference = Reference.new
		@section_report = nil
		if current_account.intern?
			@section_report = SectionReport.find_or_create_by(intern: current_user, section: @section)
			@daily_report = @section_report.daily_reports.build
			@daily_reports = @section_report.daily_reports.order(date: :desc)
		elsif current_account.trainer?
			@daily_reports = DailyReport.for_trainer(current_user.id).where(section_reports: { section_id: @section.id })
		elsif current_account.admin_user?
			@daily_reports = DailyReport.for_admin_user(current_user.id).where(section_reports: { section_id: @section.id })
		end
	end

	def update
		if @section.update(section_params)
			render json: @section, status: :ok
		else
			render json: @section.errors, status: :unprocessable_entity
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

end
