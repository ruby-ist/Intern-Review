class Section < ApplicationRecord
	validates :title, length: {minimum: 3}
	validates :context, length: {minimum: 10}
	validates :days_required, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than: 8}

	belongs_to :course
	has_many :references, dependent: :destroy

	has_many :section_reports, dependent: :destroy
	has_many :interns, through: :section_reports

	has_many :daily_reports, through: :section_reports
end
