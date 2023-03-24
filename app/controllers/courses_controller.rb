class CoursesController < ApplicationController

	before_action :not_an_intern_account!, except: %w( index show )
	before_action :authenticate_account!, only: [:index, :show]
	before_action :set_course, only: %w{ show edit update destroy }

	def index
		if current_account.intern?
			@courses = current_user.courses.order(:created_at)
		else
			@courses = Course.order(:created_at)
		end
	end

	def new
		@course = Course.new
	end

	def create
		@course = Course.new(course_params)
		@course.account_id = current_account.id
		if @course.save
			redirect_to course_path @course, notice: "New course has been created!"
		else
			render :new, status: :unprocessable_entity
		end
	end

	def show
		@sections = @course.sections
	end

	def edit
	end

	def update
		if @course.update(course_params)
			redirect_to course_path @course, notice: "Course has been updated"
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		@course.destroy!
		redirect_to courses_path, notice: "Course has been deleted!"
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
