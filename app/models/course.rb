class Course < ApplicationRecord
	validates :title, length: {minimum: 3}, uniqueness: true
	validates :duration, numericality: { only_integer: true, greater_than: 0, less_than: 91 }
	validates :image_url, format: { with: URI::regexp(%w{http https})}, allow_nil: true

	has_many :sections, dependent: :destroy
	belongs_to :account
	has_many :trainers

	has_many :course_reports, dependent: :destroy
	has_many :interns, through: :course_reports
	has_many :reviews, through: :course_reports, dependent: :destroy

	before_validation :blank_check

	def blank_check
		if image_url.blank?
			self.image_url = nil
		end
	end
end
