class CoursesController < ApplicationController

	before_action :not_an_intern_account!, except: %w( index show search )
	before_action :authenticate_account!, only: [:index, :show]
	before_action :enrolled?, only: :show
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

	def search
		if current_account.intern?
			@courses = current_user.courses.order(:created_at)
		else
			@courses = Course.order(:created_at)
		end

		query = params["query"]
		if query.present?
			@courses = @courses.where('title ILIKE ?', "%#{Course.sanitize_sql_like(query)}%" )
		end

		respond_to do |format|
			format.turbo_stream
			format.html { render :index }
		end
	end

	private

	def set_course
		@course = Course.find_by_id! params[:id].to_i
	rescue
		redirect_back fallback_location: courses_path, alert: "Invalid course Id"
	end

	def course_params
		params.require(:course).permit(:title, :description, :image_url, :duration)
	end

	def enrolled?
		unless Course.exists? params[:id].to_i
			redirect_back fallback_location: courses_path, alert: "Invalid course Id"
			return
		end

		if current_account.intern?
			unless current_user.course_ids.include? params[:id].to_i
				redirect_back fallback_location: courses_path, alert: "You are not enrolled on that course"
			end
		end
	end

end
