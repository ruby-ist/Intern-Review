class Api::ApiController < ApplicationController

	respond_to :json

	def current_account
		@current_account ||= Account.find doorkeeper_token[:resource_owner_id]
	end
end
