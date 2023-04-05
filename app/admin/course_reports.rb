ActiveAdmin.register CourseReport do

	permit_params :course_id, :intern_id, :start_date, :end_date, review_attributes: [:feedback, :admin_user_id]

	includes(:course, intern: :account, review: {admin_user: :account} )

	filter :course
	filter :intern
	filter :created_at, as: :date_range
	filter :updated_at, as: :date_range

	index do
		selectable_column
		id_column
		column :course
		column :intern
		column :status
		column :admin_user

		actions
	end

	form do |f|
		f.semantic_errors
		f.inputs
		f.inputs do
			f.has_many :review, heading: "Add review", allow_destroy: true do |a|
				a.input :feedback
				a.input :admin_user
			end
		end
		f.actions
	end

end
