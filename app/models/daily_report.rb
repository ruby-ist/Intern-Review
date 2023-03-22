class DailyReport < ApplicationRecord
	validates :date, presence: true
	validates :progress, length: { minimum: 25 }

	belongs_to :section_report

	enum status: { ongoing: 0, completed: 1 }

	scope :for_trainer, ->(id) {
		joins(section_report: { intern: { batch: :trainers }})
			.where(trainers: { id: id })
			.order(date: :desc, created_at: :desc)
			.includes(section_report: :intern)
	}

	scope :for_admin_user, -> (id) {
		joins(section_report: { intern: :batch })
			.where(batches: { admin_user_id: id })
			.order(date: :desc, created_at: :desc)
			.includes(section_report: {intern: :batch})
	}

end
