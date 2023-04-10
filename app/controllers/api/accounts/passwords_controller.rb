class Api::Accounts::PasswordsController < Api::ApiController
	before_action :doorkeeper_authorize!

	def update
		account = Account.authenticate!(current_account.email, params[:current_password])
		if account.present?
			if account.reset_password(password_params[:password], password_params[:password_confirmation])
				render json: { message: "password successfully changed" }, status: :ok
			else
				render json: { errors: account.errors }, status: :unprocessable_entity
			end
		else
			render json: {errors: {password: "is invalid! "}}, status: :unprocessable_entity
		end
	end

	private

	def password_params
		params.require(:account).permit(:password, :password_confirmation)
	end
end