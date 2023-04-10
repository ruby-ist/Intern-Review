# frozen_string_literal: true

class Accounts::SessionsController < Devise::SessionsController
	# before_action :configure_sign_in_params, only: [:create]
	prepend_before_action :captcha_valid, :only => [:create]

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
		unless verify_recaptcha
			self.resource = resource_class.new(sign_in_params)
			clean_up_passwords resource
			flash.now[:alert] = "You need to fill the reCaptcha box before submitting the form"
			render :new, status: :unprocessable_entity
		end
	end
end
