class ApplicationController < ActionController::Base
	def current_user
		current_account.accountable
	end

	def not_an_intern_account!
		unless account_signed_in?
			authenticate_account!
		end

		if current_account.intern?
			redirect_back fallback_location: account_path(current_account), alert: "You are not authorised to do that!"
		end
	end

	def admin_account!
		unless current_account.admin_user?
			redirect_back fallback_location: account_path(current_account), alert: "You are not authorised to do that!"
		end
	end

	def intern_account!
		unless current_account.intern?
			redirect_back fallback_location: account_path(current_account), alert: "You are not authorised to do that!"
		end
	end
end
