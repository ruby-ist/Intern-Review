class CreateRoles < ActiveRecord::Migration[6.0]
	def change
		create_table :admins do |t|
			t.timestamps
		end

		create_table :trainers do |t|
			t.references :admin
			t.timestamps
		end

		create_table :interns do |t|
			t.string :technology
			t.timestamps
		end

		create_table :interns_trainers, id: false do |t|
			t.belongs_to :trainer
			t.belongs_to :intern

			t.timestamps
		end

		create_table :courses_trainers, id: false do |t|
			t.belongs_to :trainer
			t.belongs_to :course

			t.timestamps
		end

		create_table :section_reports do |t|
			t.belongs_to :section
			t.belongs_to :intern

			t.date :start_date
			t.date :end_date
			t.integer :status, default: 0

			t.timestamps
		end

		create_table :course_reports do |t|
			t.belongs_to :course
			t.belongs_to :intern

			t.date :start_date
			t.date :end_date

			t.timestamps
		end

		create_table :reviews do |t|
			t.text :feedback
			t.references :admin
			t.references :course_report

			t.timestamps
		end
	end
end
