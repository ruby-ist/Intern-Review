class ApplicationController < ActionController::Base


	def current_user
		current_account.accountable
	end

	def not_an_intern_account!
		unless account_signed_in?
			authenticate_account!
		end

		if current_account.intern?
			redirect_back fallback_location: "/dashboard" ,alert: "You are not authorised to do that!"
		end
	end

	def admin_account!
		unless current_account.admin?
			redirect_back fallback_location: "/dashboard" ,alert: "You are not authorised to do that!"
		end
	end
end
