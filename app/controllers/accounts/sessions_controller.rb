# frozen_string_literal: true

class Accounts::SessionsController < Devise::SessionsController
	# before_action :configure_sign_in_params, only: [:create]
	prepend_before_action :captcha_valid, :only => [ :create]


	# GET /resource/sign_in
	# def new
	#   super
	# end

	# POST /resource/sign_in
	def create
		super
	end

	# DELETE /resource/sign_out
	# def destroy
	#   super
	# end

	# protected

	# If you have extra params to permit, append them to the sanitizer.
	# def configure_sign_in_params
	#   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
	# end

	private

	def captcha_valid
		if verify_recaptcha
			true
		else
			flash.delete(:recaptcha_error)
			flash[:alert] = "You need fill the reCaptcha box before submitting the form"
			redirect_to new_account_session_path
		end
	end
end
