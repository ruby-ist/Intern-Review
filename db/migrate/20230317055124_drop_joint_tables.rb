class DropJointTables < ActiveRecord::Migration[6.0]
	def up
		drop_table :courses_trainers
		drop_table :interns_trainers

		create_table :batches do |t|
			t.string :name
			t.integer :status, default: 0
			t.belongs_to :admin

			t.timestamps
		end

		add_reference :trainers, :course
		add_reference :trainers, :batch
		add_reference :interns, :batch
	end

	def down
		remove_reference :trainers, :course
		remove_reference :trainers, :batch
		remove_reference :interns, :batch

		drop_table :batches

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
	end
end
