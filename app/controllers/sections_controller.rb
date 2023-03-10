class SectionsController < ApplicationController

	before_action :set_course, only: %w{ new create }
	before_action :set_section, only: %w{ show }

	def new
		@section = Section.new
	end

	def create
		@section = @course.sections.build(section_params)
		respond_to do |format|
			if @section.save
				format.html{ redirect_to course_path(@course) }
			else
				format.html{ render :new, status: :unprocessable_entity}
			end
		end
	end

	def show
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
