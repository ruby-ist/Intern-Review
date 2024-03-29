ActiveAdmin.register Course do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# Uncomment all parameters which should be permitted for assignment
	#
	permit_params :title, :description, :duration, :image_url, :account_id

	includes(:account)

	filter :title
	filter :duration
	filter :description
	filter :account
	filter :created_at, as: :date_range
	filter :updated_at, as: :date_range

	index do
		selectable_column
		id_column
		column :title
		column :duration
		column "Created by", :account

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
