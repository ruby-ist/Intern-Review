ActiveAdmin.register AdminUser do
	permit_params :email, :password, :password_confirmation, account_attributes: [:name, :email, :password, :password_confirmation, :_destroy]

	before_action :check_current_admin, only: [:edit, :update, :destroy]

	controller do
		def check_current_admin
			unless current_admin_user.id == params[:id].to_i
				redirect_back fallback_location: admin_root_path
			end
		end
	end

	index do
		selectable_column
		id_column
		column :email
		column :name
		column :current_sign_in_at
		column :sign_in_count
		column :created_at
		actions
	end

	filter :email
	filter :current_sign_in_at
	filter :sign_in_count
	filter :created_at

	action_item :view, only: :show do
		link_to 'View on site', account_path(resource.account)
	end

	# action_item :super

	form do |f|
		f.inputs do
			f.input :email
			f.input :password
			f.input :password_confirmation
		end

		f.inputs do
			f.has_many :account, heading: "App Account Details", allow_destroy: true do |a|
				a.input :name
				a.input :email
				a.input :password
				a.input :password_confirmation
			end
		end
		f.actions
	end

end
