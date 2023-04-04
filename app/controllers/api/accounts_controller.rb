class Api::AccountsController < Api::ApiController

	before_action :doorkeeper_authorize!

	def show
		@account = Account.find params[:id]
		@user = @account.accountable
		if current_account.intern? && params[:id].to_i != current_account.id
			render json: {error: "You're not authorised to do that"}, status: :forbidden
			return
		end

		if current_account.trainer? && !(@account.intern? || current_account == @account)
			render json: {error: "You're not authorised to do that"}, status: :forbidden
			return
		end

		case @account.accountable_type
		when "Intern"
			@section_reports = @user.section_reports.dated_reports
			@batch = @user.batch
			@trainers = @batch.trainers.includes(:account)
			@course_reports = CourseReport.where(intern: @user).includes(:course)
		when "Trainer"
			@batch = @user.batch
			@interns = @batch.interns.includes(:account)
			@course = @user.course
		when "AdminUser"
			@batches = @user.batches.includes(trainers: :account, interns: :account)
			@reviews = @user.reviews.includes(course_report: [:intern, :course])
		end
	rescue
		render json: {error: "Record not found"}
	end

	def update
		if current_account.update(account_params)
			render partial: "api/accounts/account", locals: {account: current_account}, status: :ok
		else
			render json: { errors: current_account.errors }, status: :unprocessable_entity
		end
	end

	private

	def account_params
		params.require(:account).permit(:name, :avatar_url)
	end
end
