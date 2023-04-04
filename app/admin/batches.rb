ActiveAdmin.register Batch do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# Uncomment all parameters which should be permitted for assignment
	#
	permit_params :name, :status, :admin_user_id

	scope :active
	scope :inactive

	includes(admin_user: :account)

	filter :admin_user, as: :select, collection: AdminUser.includes(:account).distinct
	 												.collect { |admin_user| [admin_user.account.name, admin_user.id]}

	filter :trainers, as: :select, collection: Trainer.includes(:account).distinct
													.collect { |trainer| [trainer.account.name, trainer.id]}

	filter :interns, as: :select, collection: Intern.includes(:account).distinct
													.collect { |intern| [intern.account.name, intern.id]}
	filter :name
	filter :created_at, as: :date_range
	filter :updated_at, as: :date_range

	includes(trainers: :account, interns: :account, admin_user: :account)

	index do
		selectable_column
		id_column
		column :name
		column :status
		column :admin_user

		actions
	end

end
