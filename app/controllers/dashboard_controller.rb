class DashboardController < ApplicationController

	before_action :authenticate_account!

	def index
		request.variant = user_sym
		@user = current_account.accountable

		unless request.variant.include? :intern
			@type = "all"
			if params['date'] == "all"
				@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id)
			elsif params['date']
				begin
					@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id).where(date: params['date'].to_date)
				rescue
					@daily_reports = DailyReport.none
				end
			else
				@type = "today"
				@daily_reports = DailyReport.send("for_#{user_sym.to_s}", @user.id).where(date: Date.today)
			end
		end
	end

	private

	def user_sym
		current_account.accountable_type.downcase.to_sym
	end
end
