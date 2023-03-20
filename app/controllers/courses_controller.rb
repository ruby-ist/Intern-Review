class CoursesController < ApplicationController

	before_action :not_an_intern_account!, except: %w( show )
	before_action :authenticate_account!, only: :show
	before_action :set_course, only: %w{ show edit update destroy }

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
				format.html { render :new, status: :unprocessable_entity }
			end
		end
	end

	def show
		@sections = @course.sections
	end

	def edit
	end

	def update
		respond_to do |format|
			if @course.update(course_params)
				format.html { redirect_to course_path @course }
			else
				format.html { render :edit, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		course.destroy!
		redirect_to courses_path, status: :see_other
	end

	private

	def set_course
		@course = Course.find params[:id]
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def course_params
		params.require(:course).permit(:title, :description, :image_url, :duration)
	end

end
