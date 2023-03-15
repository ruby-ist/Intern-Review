class DashboardController < ApplicationController

	before_action :authenticate_account!

	def index
		request.variant = current_account.accountable_type.to_sym
		@user = current_account.accountable
	end

end
