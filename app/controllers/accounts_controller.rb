class AccountsController < ApplicationController
	before_action :authenticate_account!

	def show
		@account = Account.find params[:id]
		@user = @account.accountable

		if current_account.intern? && params[:id].to_i != current_account.id
			redirect_back fallback_location: account_path(current_account.id), alert: "You're not authorised to do that"
		end

		if current_account.trainer? && !(@account.intern? || current_account == @account)
			redirect_back fallback_location: account_path(current_account.id), alert: "You're not authorised to do that"
		end

		case @account.accountable_type
		when "Intern"
			@section_reports = @user.section_reports.dated_reports
			@batch = @user.batch
			@trainers = @batch.trainers
			@course_reports = CourseReport.where(intern: @user).includes(:course)
			@reviews = @user.reviews.includes(:admin_user, course_report: :course)
		when "Trainer"
			@batch = @user.batch
			@interns = @batch.interns
			@course = @user.course
		when "AdminUser"
			@batches = @user.batches.includes(:trainers, :interns)
			@reviews = @user.reviews.includes(course_report: [:intern, :course])
		end
	rescue
		redirect_back fallback_location: root_path, alert: "Record not found", status: :see_other
	end


	def edit
	end

	def update
		if current_account.update(account_params)
			redirect_to account_path(current_account), notice: "Account Details Updated"
		else
			render :edit, status: :unprocessable_entity
		end
	end

	private

	def account_params
		params.require(:account).permit(:name, :avatar_url)
	end

end
