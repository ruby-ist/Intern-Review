class Review < ApplicationRecord
	validates :feedback, length: {minimum: 30}

	belongs_to :admin
	belongs_to :course_report
end