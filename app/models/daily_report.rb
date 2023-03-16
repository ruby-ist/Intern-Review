class DailyReport < ApplicationRecord
	validates :date, presence: true
	validates :progress, length: {minimum: 25}

	belongs_to :section_report

	enum status: {ongoing: 0, completed: 1}

	scope :for_trainer, ->(id) {
		joins(section_report: {intern: :interns_trainers})
		.where(interns_trainers: {trainer_id: id})
		.order(date: :desc, created_at: :desc)
		.includes(section_report: :intern)
	}

end
