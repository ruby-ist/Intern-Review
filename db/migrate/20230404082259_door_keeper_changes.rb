class DoorKeeperChanges < ActiveRecord::Migration[6.0]
	def change
		create_table :oauth_applications do |t|
			t.string :name, null: false
			t.string :uid, null: false
			t.string :secret, null: false

			# Remove `null: false` if you are planning to use grant flows
			# that doesn't require redirect URI to be used during authorization
			# like Client Credentials flow or Resource Owner Password.
			t.text :redirect_uri
			t.string :scopes, null: false, default: ''
			t.boolean :confidential, null: false, default: true
			t.timestamps null: false
		end

		add_index :oauth_applications, :uid, unique: true

		add_foreign_key(
			:oauth_access_tokens,
			:oauth_applications,
			column: :application_id
		)
	end
end
