class Review < ApplicationRecord
	validates :feedback, length: {minimum: 30}

	belongs_to :admin_user
	belongs_to :course_report
end