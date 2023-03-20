class ReviewsController < ApplicationController
	before_action :authenticate_account!
	before_action :admin_account!
	before_action :set_review, except: [:new, :create]

	def new
		@course_report = CourseReport.find params[:course_report_id]
		@review = current_user.reviews.build
	end

	def create
		@review = current_user.reviews.build(review_params)
		@review.course_report_id = params[:course_report_id]

		respond_to do |format|
			if @review.save
				format.html{ redirect_to account_path(current_account) }
			else
				format.html{ render :new, status: :unprocessable_entity}
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @review.update(review_params)
				format.html{ redirect_to account_path(current_account) }
			else
				format.html{ render :new, status: :unprocessable_entity}
			end
		end
	end

	def destroy
		@review.destroy!
		redirect_to account_path(current_account)
	end

	private

	def review_params
		params.require(:review).permit(:feedback)
	end

	def set_review
		@review = Review.find params[:id]
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end
end
