class ReviewsController < ApplicationController
	before_action :authenticate_account!
	before_action :admin_account!, except: [:edit_progress, :update_progress, :cancel_progress, :mark_complete]
	before_action :intern_account!, only: [:edit_progress, :update_progress, :cancel_progress, :mark_complete]
	before_action :set_review, except: [:new, :create]
	before_action :associated_review, only: [:edit_progress, :update_progress, :cancel_progress, :mark_complete]

	def new
		@course_report = CourseReport.find_by_id! params[:course_report_id].to_i
		@review = current_user.reviews.build
	rescue
		redirect_back fallback_location: courses_path, alert: "Invalid CourseReport Id"
	end

	def create
		@review = current_user.reviews.build(review_params)
		@review.course_report_id = params[:course_report_id].to_i

		if @review.save
			redirect_to account_path(current_account), notice: "A new review is created"
		else
			render :new, status: :unprocessable_entity
		end
	end

	def edit
	end

	def update
		if @review.update(review_params)
			redirect_to account_path(current_account), notice: "Review has been successfully updated"
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		@review.destroy!
		redirect_to account_path(current_account), notice: "Review is deleted successfully"
	end

	def edit_progress
		respond_to do |format|
			format.turbo_stream do
				render turbo_stream: turbo_stream.replace(@review,
														  partial: 'reviews/review',
														  locals: { review: @review, progress: true })
			end
			format.html
		end
	end

	def update_progress
		respond_to do |format|
			if @review.update(progress_param)
				format.turbo_stream { render turbo_stream: turbo_stream.replace(@review) }
				format.html { redirect_to account_path(current_account), notice: "Progress has been added" }
			else
				format.turbo_stream do
					render turbo_stream: turbo_stream.update("review_#{@review.id}_form",
															 partial: "reviews/progress_form",
															 locals: { review: @review })
				end
				format.html { redirect_back fallback_location: account_path(current_account) }
			end
		end
	end

	def cancel_progress
		respond_to do |format|
			format.turbo_stream do
				render turbo_stream: turbo_stream.replace(@review,
														  partial: 'reviews/review',
														  locals: { review: @review, progress: false })
			end
			format.html { redirect_back fallback_location: account_path(current_account) }
		end
	end

	def mark_complete
		if @review.pending?
			@review.complete!
		else
			@review.pending!
		end
		respond_to do |format|
			format.turbo_stream { render turbo_stream: turbo_stream.replace(@review) }
			format.html { redirect_back fallback_location: account_path(current_account) }
		end
	end

	private

	def review_params
		params.require(:review).permit(:feedback)
	end

	def set_review
		@review = Review.find_by_id! params[:id].to_i
	rescue
		redirect_back fallback_location: account_path(current_account), alert: "Invalid review Id"
	end

	def progress_param
		params.require(:review).permit(:progress)
	end

	def associated_review
		if @review.course_report.intern_id != current_user.id
			redirect_back fallback_location: account_path(current_account), notice: "You don't have access to that review"
		end
	end

end
