class ChangeColumns < ActiveRecord::Migration[6.0]
	def up
		remove_reference :daily_reports, :course
		remove_reference :daily_reports, :section

		add_reference :daily_reports, :section_report
		add_reference :courses, :account
	end

	def down
		add_reference :daily_reports, :course
		add_reference :daily_reports, :section

		remove_reference :daily_reports, :section_report
		remove_reference :courses, :account
	end
end
