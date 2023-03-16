class DashboardController < ApplicationController

	before_action :authenticate_account!

	def index
		request.variant = current_account.accountable_type.to_sym
		@user = current_account.accountable

		if request.variant.include? :Trainer
			@type = "all"
			if params['date'] == "all"
				@daily_reports = DailyReport.for_trainer(@user.id)
			elsif params['date']
				begin
					@daily_reports = DailyReport.for_trainer(@user.id).where(date: params['date'].to_date)
				rescue
					@daily_reports = DailyReport.none
				end
			else
				@type = "today"
				@daily_reports = DailyReport.for_trainer(@user.id).where(date: Date.today)
			end
		elsif request.variant.include? :Admin
			@trainers = @user.trainers.includes(interns: :account)
		end
	end
end
