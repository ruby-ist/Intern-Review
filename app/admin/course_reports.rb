ActiveAdmin.register CourseReport do

	permit_params :course_id, :intern_id, :start_date, :end_date, review_attributes: [:feedback, :admin_id]


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
