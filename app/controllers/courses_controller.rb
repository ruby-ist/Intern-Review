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
		respond_to do |format|
			if @course.save
				format.html { redirect_to course_path @course }
				format.json { render json: @course, status: :created }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { render json: @course.errors, status: :unprocessable_entity }
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
				format.html { render json: @course, status: :ok }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { render json: @course.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		course.destroy!
		respond_to do |format|
			format.html { redirect_to courses_path, status: :see_other }
			format.json { head :no_content }
		end
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
