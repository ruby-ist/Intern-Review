ActiveAdmin.register Batch do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# Uncomment all parameters which should be permitted for assignment
	#
	permit_params :name, :status, :admin_user_id

	scope :all
	scope :active
	scope :inactive

	includes(admin_user: :account)

	filter :admin_user
	filter :trainers
	filter :interns

	filter :name
	filter :created_at, as: :date_range
	filter :updated_at, as: :date_range

	index do
		selectable_column
		id_column
		column :name
		column :status
		column :admin_user

		actions
	end

end
