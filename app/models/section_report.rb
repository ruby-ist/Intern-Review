class SectionReport < ApplicationRecord
	belongs_to :intern
	belongs_to :section

	enum status: {ongoing: 0, completed: 1}

	has_many :daily_reports, dependent: :destroy

	scope :dated_reports, -> { includes(:section, daily_reports: {intern: :account}).order(start_date: :desc).order('daily_reports.date DESC') }
end