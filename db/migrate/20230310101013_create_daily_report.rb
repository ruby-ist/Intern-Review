class CreateDailyReport < ActiveRecord::Migration[6.0]
	def change
		create_table :daily_reports do |t|
			t.date :date
			t.integer :status, default: 0
			t.text :progress
			t.text :feedback
			t.references :course
			t.references :section

			t.timestamps
		end
	end
end
