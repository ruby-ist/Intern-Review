ActiveAdmin.register Trainer do

	permit_params :admin_id, :course_id, :batch_id, account_attributes: [:name, :email, :password, :password_confirmation, :_destroy]

	index do
		selectable_column
		id_column
		column :name
		column :email
		column :course
		column :admin
		column :batch
		actions
	end

	action_item :view, only: :show do
		link_to 'View on site', account_path(resource.account)
	end

	form do |f|
		f.semantic_errors
		f.inputs
		f.inputs do
			f.has_many :account, heading: "Account Details", allow_destroy: true do |a|
				a.input :name
				a.input :email
				a.input :password
				a.input :password_confirmation
			end
		end
		f.actions
	end
end
