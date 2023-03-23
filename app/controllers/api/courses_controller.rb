class Api::CoursesController < Api::ApiController

	before_action :doorkeeper_authorize!
	before_action :set_course, only: %w{ show update destroy }

	def index
		if current_account.intern?
			@courses = current_user.courses.order(:created_at)
		else
			@courses = Course.order(:created_at)
		end
	end

	def create
		@course = Course.new(course_params)
		if @course.save
			render json: @course, status: :created
		else
			render json: @course.errors, status: :unprocessable_entity
		end
	end

	def show
		@sections = @course.sections
	end

	def update
		if @course.update(course_params)
			render json: @course, status: :ok
		else
			render json: @course.errors, status: :unprocessable_entity
		end
	end

	def destroy
		course.destroy!
		head :no_content
	end

	private

	def set_course
		@course = Course.find params[:id]
	rescue
		render json: {error: "Course not found"}, status: :not_found
	end

	def course_params
		params.require(:course).permit(:title, :description, :image_url, :duration)
	end

end

