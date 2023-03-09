class CoursesController < ApplicationController

	def index
		@courses = Course.all
	end

	def new
		@course = Course.new
	end

	def create
		@course = Course.new(course_params)
		respond_to do |format|
			if @course.save
				format.html { redirect_to courses_path }
			else
				format.html { render :new, status: :unprocessable_entity }
			end
		end
	end

	private

	def course_params
		params.require(:course).permit(:title, :description, :image_url, :duration)
	end

end
