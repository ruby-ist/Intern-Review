class Api::ApiController < ApplicationController
	skip_before_action :verify_authenticity_token
	respond_to :json

	def current_account
		@current_account ||= Account.find doorkeeper_token[:resource_owner_id]
	end

	def not_an_intern_account!
		if current_account.intern?
			render json: {errors: {account: "does not have that privilege"}}, status: :non_authoritative_information
		end
	end

	def admin_account!
		unless current_account.admin_user?
			render json: {errors: {account: "does not have that privilege"}}, status: :non_authoritative_information
		end
	end
end
