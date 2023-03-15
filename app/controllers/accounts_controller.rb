class AccountsController < ApplicationController

	before_action :authenticate_account!

	def show
		@account = Account.find params[:id]
		@user = @account.accountable

		if @account.intern? && params[:id].to_i != current_account.id
			redirect_back fallback_location: account_path(current_account.id)
		end

		case @account.accountable_type
		when "Intern"
			@section_reports = @user.section_reports.includes(:daily_reports, :section).order(start_date: :desc)
		end
	end

end
