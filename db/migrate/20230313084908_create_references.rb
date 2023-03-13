class CreateReferences < ActiveRecord::Migration[6.0]
	def change
		create_table :references do |t|
			t.string :url
			t.references :section

			t.timestamps
		end
	end
end
