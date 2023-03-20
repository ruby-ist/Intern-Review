class Admin < ApplicationRecord
	has_one :account, as: :accountable
	has_many :reviews
	has_many :batches

	delegate_missing_to :account
end
