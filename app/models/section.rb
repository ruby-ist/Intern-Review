class Section < ApplicationRecord
	validates :title, presence: true, length: {minimum: 3}
	validates :context, presence: true, length: {minimum: 10}
	validates :days_required, presence: true, numericality: {greater_than_or_equal_to: 1}

	belongs_to :course
	has_many :references, dependent: :destroy

	has_many :section_reports
	has_many :interns, through: :section_reports

	has_many :daily_reports, through: :section_reports
end
