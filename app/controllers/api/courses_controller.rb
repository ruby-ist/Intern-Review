class Api::CoursesController < Api::ApiController

	before_action :doorkeeper_authorize!
	before_action :enrolled?, only: :show
	before_action :not_an_intern_account!, except: %w( index show )
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
		@course.account_id = current_account.id
		if @course.save
			render partial: "api/courses/course", locals: {course: @course}, status: :created
		else
			render json: { errors: @course.errors }, status: :unprocessable_entity
		end
	end

	def show
		@sections = @course.sections
	end

	def update
		if @course.update(course_params)
			render partial: "api/courses/course", locals: {course: @course}, status: :ok
		else
			render json: { errors: @course.errors }, status: :unprocessable_entity
		end
	end

	def destroy
		@course.destroy!
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

	def enrolled?
		if current_account.intern?
			unless current_user.course_ids.include? params[:id].to_i
				render json: {errors: {intern: "not enrolled for the course" }}, status: :forbidden
				return
			end
		end
	end

end

