class DailyReport < ApplicationRecord
	validates :date, presence: true
	validates :progress, length: {minimum: 25}
	validates :course_id, presence: true
	validates :section_id, presence: true

	enum status: {ongoing: 0, completed: 1}

end
