class CourseReport < ApplicationRecord
	belongs_to :course
	belongs_to :intern

	has_one :review, dependent: :destroy
end
