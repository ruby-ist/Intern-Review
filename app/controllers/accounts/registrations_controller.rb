# frozen_string_literal: true

class Accounts::RegistrationsController < Devise::RegistrationsController
	skip_before_action :require_no_authentication, only: [:new, :create]
	before_action :configure_sign_up_params, only: [:create]
	before_action :authenticate_account!
	before_action :admin_account!, only: [:new, :create]
	# before_action :configure_account_update_params, only: [:update]

	# GET /resource/sign_up
	# def new
	#   super
	# end

	# POST /resource
	def create
		if account_signed_in?
			self.resource = resource_class.new(sign_up_params)
		else
			build_resource(sign_up_params)
		end

		if %w(Intern Trainer Admin).include? resource.accountable_type

			accountable = case resource.accountable_type
						  when "Intern"
							  @batch = Batch.find_by(name: params[:batch_name])
							  Intern.create(technology: params[:technology], batch: @batch)
						  when "Trainer"
							  @course = Course.find_by(title: params[:course_name])
							  @batch = Batch.find_by(name: params[:batch_name])
							  Trainer.create(admin: current_account.accountable, course: @course, batch: @batch )
						  when "Admin"
							  Admin.create!
						  else
							  raise "Invalid User Type"
						  end
			resource.accountable_id = accountable.id
			unless resource.save
				unless resource.admin?
					unless @batch
						resource.errors.messages[:batch] = ["must exist"]
					end
				end

				if resource.trainer?
					unless @course
						resource.errors.messages[:course] = ["must exist"]
					end
				end
				accountable.destroy!
			end
		else
			raise "Invalid account type"
		end

		if resource.persisted?
			if resource.active_for_authentication?
				set_flash_message! :notice, :signed_up
				sign_up(resource_name, resource)
				respond_with resource, location: after_sign_up_path_for(resource)
			else
				set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
				expire_data_after_sign_in!
				respond_with resource, location: after_inactive_sign_up_path_for(resource)
			end
		else
			clean_up_passwords resource
			set_minimum_password_length
			respond_with resource
		end
	end

	# GET /resource/edit
	# def edit
	#   super
	# end

	# PUT /resource
	# def update
	#   super
	# end

	# DELETE /resource
	# def destroy
	#   super
	# end

	# GET /resource/cancel
	# Forces the session data which is usually expired after sign
	# in to be expired now. This is useful if the user wants to
	# cancel oauth signing in/up in the middle of the process,
	# removing all OAuth session data.
	# def cancel
	#   super
	# end

	# protected

	# If you have extra params to permit, append them to the sanitizer.
	def configure_sign_up_params
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar_url, :accountable_type])
	end

	# If you have extra params to permit, append them to the sanitizer.
	# def configure_account_update_params
	#   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
	# end

	# The path used after sign up.
	# def after_sign_up_path_for(resource)
	#   super(resource)
	# end

	# The path used after sign up for inactive accounts.
	# def after_inactive_sign_up_path_for(resource)
	#   super(resource)
	# end
end
