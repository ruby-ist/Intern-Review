ActiveAdmin.register Intern do

	permit_params :technology, :batch_id, account_attributes: [:name, :email, :password, :password_confirmation, :_destroy]

	filter :batch
	filter :trainers
	filter :technology, as: :select, collection: Course.all.collect { |course| [course.title, course.title] }

	index do
		selectable_column
		id_column
		column :name
		column :email
		column :technology
		column :batch
		actions
	end

	action_item :view, only: :show do
		link_to 'View on site', account_path(resource.account)
	end

	form do |f|
		f.semantic_errors
		f.inputs do
			f.input :batch
			f.input :technology, as: :select, collection: Course.all.collect { |course| [course.title, course.title] }
		end
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
