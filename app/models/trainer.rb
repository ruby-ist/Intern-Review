class Trainer < ApplicationRecord
	belongs_to :admin
	has_one :account, as: :accountable

	has_and_belongs_to_many :courses
	has_and_belongs_to_many :interns

	delegate_missing_to :account
end
