class Admin < ApplicationRecord
	has_one :account, as: :accountable
	has_many :trainers
	has_many :reviews

	delegate_missing_to :account
end
