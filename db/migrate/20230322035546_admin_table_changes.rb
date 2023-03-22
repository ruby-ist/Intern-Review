class AdminTableChanges < ActiveRecord::Migration[6.0]
	def up
		remove_reference :trainers, :admin
		remove_reference :batches, :admin
		remove_reference :reviews, :admin

		drop_table :admins

		add_reference :batches, :admin_user
		add_reference :reviews, :admin_user
	end

	def down
		remove_reference :batches, :admin_user
		remove_reference :reviews, :admin_user

		create_table :admins do |t|
			t.timestamps
		end

		add_reference :trainers, :admin
		add_reference :batches, :admin
		add_reference :reviews, :admin
	end
end
