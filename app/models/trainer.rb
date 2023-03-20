class Trainer < ApplicationRecord
	belongs_to :admin
	belongs_to :course
	belongs_to :batch
	has_one :account, as: :accountable

	has_many :interns, through: :batch

	delegate_missing_to :account
end
