class CoursesController < ApplicationController

	def index
		@courses = Course.order(:created_at)
	end

	def new
		@course = Course.new
	end

	def create
		@course = Course.new(course_params)
		respond_to do |format|
			if @course.save
				format.html { redirect_to course_path @course }
			else
				format.turbo_stream
				format.html { render :new, status: :unprocessable_entity }
			end
		end
	end

	def show
		@course = Course.find params[:id]
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def edit
		@course = Course.find params[:id]
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def update
		@course = Course.find params[:id]
		if @course.update(course_params)
			redirect_to course_path @course
		else
			render :edit, status: :unprocessable_entity
		end
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def destroy
		course = Course.find params[:id]
		p course
		course.destroy!
		redirect_to courses_path, status: :see_other
	end

	private

	def course_params
		params.require(:course).permit(:title, :description, :image_url, :duration)
	end

end
