ActiveAdmin.register Batch do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# Uncomment all parameters which should be permitted for assignment
	#
	permit_params :name, :status, :admin_user_id

	scope :active
	scope :inactive


	index do
		selectable_column
		id_column
		column :name
		column :status
		column :admin_user

		actions
	end
	#
	# or
	#
	# permit_params do
	#   permitted = [:name, :status, :admin_id]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

end
