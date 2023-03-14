class DailyReport < ApplicationRecord
	validates :date, presence: true
	validates :progress, length: {minimum: 25}

	belongs_to :section_report

	enum status: {ongoing: 0, completed: 1}

end
