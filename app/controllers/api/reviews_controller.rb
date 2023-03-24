class Api::ReviewsController < Api::ApiController
	before_action :doorkeeper_authorize!
	before_action :admin_account!
	before_action :set_review, except: :create

	def create
		@review = current_user.reviews.build(review_params)
		@review.course_report_id = params[:course_report_id]
		if @review.save
			render partial: "api/reviews/review", locals: {review: @review}, status: :created
		else
			render json: {errors: @review.errors}, status: :unprocessable_entity
		end
	end

	def update
		if @review.update(review_params)
			render partial: "api/reviews/review", locals: {review: @review}, status: :ok
		else
			render json: {errors: @review.errors}, status: :unprocessable_entity
		end
	end

	def destroy
		@review.destroy!
		head :no_content
	end

	private

	def review_params
		params.require(:review).permit(:feedback)
	end

	def set_review
		@review = Review.find params[:id]
	rescue
		render json: { error: "Review not found!" }, status: :not_found
	end
end