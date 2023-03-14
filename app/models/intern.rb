class Intern < ApplicationRecord
	validates :technology, presence: true

	has_one :account, as: :accountable

	has_many :section_reports
	has_many :sections, through: :section_reports

	has_many :course_reports
	has_many :courses, through: :course_reports

	has_and_belongs_to_many :trainers

	delegate_missing_to :account
end
