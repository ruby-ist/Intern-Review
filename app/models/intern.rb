class Intern < ApplicationRecord
	validates :technology, presence: true

	belongs_to :batch
	has_many :trainers, through: :batch

	has_one :account, as: :accountable
	accepts_nested_attributes_for :account

	has_many :section_reports
	has_many :sections, through: :section_reports

	has_many :course_reports
	has_many :courses, through: :course_reports

	has_many :reviews, through: :course_reports

	delegate_missing_to :account
end
