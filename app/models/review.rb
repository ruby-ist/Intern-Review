class Review < ApplicationRecord
	validates :feedback, length: {minimum: 30}
	validates :progress, length: {minimum: 10}, allow_blank: true

	enum :status => [:pending, :complete]

	belongs_to :admin_user
	belongs_to :course_report

	has_one :intern, through: :course_report
	has_one :course, through: :course_report
end