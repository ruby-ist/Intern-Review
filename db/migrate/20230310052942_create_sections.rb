class CreateSections < ActiveRecord::Migration[6.0]
	def change
		create_table :sections do |t|
			t.string :title
			t.integer :days_required
			t.text :context
			t.belongs_to :course

			t.timestamps
		end
	end
end
