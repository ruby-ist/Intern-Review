class DailyReport < ApplicationRecord
	validates :date, presence: true
	validates :progress, length: { minimum: 25 }
	validates :feedback, length: { minimum: 5 }, allow_nil: true

	belongs_to :section_report

	enum status: { ongoing: 0, completed: 1 }

	scope :order_by_date, -> {
		order(date: :desc, created_at: :desc)
	}

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
	
	before_save do
		report = section_report

		if report.daily_reports.count == 0
			report.start_date = date
		end

		if completed?
			report.end_date = date
			report.completed!
		end
		report.save!
	end

	after_update do
		report = section_report
		daily_reports = report.daily_reports.order_by_date
		if daily_reports.first == self
			if ongoing?
				report.end_date = nil
				report.ongoing!
			elsif completed?
				report.end_date = date
				report.completed!
			end
			report.save!
		end
	end

	before_destroy do
		report = section_report
		daily_reports = report.daily_reports.order_by_date
		if daily_reports.first == self
			if completed?
				report.end_date = nil
				report.ongoing!
			end
		end

		if daily_reports.size == 1
			report.start_date = nil
			report.ongoing!
		end

		report.save!
	end

end
