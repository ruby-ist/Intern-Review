class Course < ApplicationRecord
	validates :title, presence: true, length: {minimum: 3}
	validates :duration, presence: true, numericality: {only_integer: true }

	has_many :sections, dependent: :destroy
	belongs_to :account
	has_and_belongs_to_many :trainers

	has_many :course_reports
	has_many :interns, through: :course_reports
	has_many :reviews, through: :course_reports

	after_validation :blank_check

	def blank_check
		if image_url.blank?
			self.image_url = nil
		end
	end

end
