# frozen_string_literal: true

class Accounts::PasswordsController < Devise::PasswordsController

	skip_before_action :assert_reset_token_passed, only: :edit
	skip_before_action :require_no_authentication,  only: [:edit, :update]
	before_action :authenticate_account!

	def edit
		self.resource = current_account
	end

	def update
		account = Account.authenticate!(current_account.email, params[:current_password])
		if account.present?
			if account.reset_password(password_params[:password], password_params[:password_confirmation])
				bypass_sign_in(account)
				redirect_to account_path(current_account), notice: "password successfully changed"
			else
				self.resource = account
				render 'devise/passwords/edit', status: :unprocessable_entity
			end
		else
			redirect_to edit_account_password_path, alert: "Invalid password!"
		end
	end

	# protected

	# def after_resetting_password_path_for(resource)
	#   super(resource)
	# end

	# The path used after sending reset password instructions
	# def after_sending_reset_password_instructions_path_for(resource_name)
	#   super(resource_name)
	# end

	private

	def password_params
		params.require(:account).permit(:password, :password_confirmation)
	end
end
