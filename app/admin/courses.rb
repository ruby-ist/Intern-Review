ActiveAdmin.register Course do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# Uncomment all parameters which should be permitted for assignment
	#
	permit_params :title, :description, :duration, :image_url, :account_id

	filter :title
	filter :duration
	filter :description
	filter :account

	index do
		selectable_column
		id_column
		column :title
		column :duration
		column :image_url

		actions
	end
	#
	# or
	#
	# permit_params do
	#   permitted = [:title, :description, :duration, :image_url, :account_id]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

end
