ActiveAdmin.register Trainer do

	permit_params :course_id, :batch_id, account_attributes: [:name, :email, :password, :password_confirmation, :_destroy]

	includes :account, :batch, :course

	filter :course
	filter :batch
	filter :interns , as: :select, collection: Intern.includes(:account).distinct
													 .collect { |intern| [intern.account.name, intern.id] }
	filter :created_at, as: :date_range
	filter :updated_at, as: :date_range

	index do
		selectable_column
		id_column
		column :name
		column :email
		column :course
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
