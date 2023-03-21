class Trainer < ApplicationRecord
	belongs_to :admin
	belongs_to :course
	belongs_to :batch
	has_one :account, as: :accountable
	accepts_nested_attributes_for :account

	has_many :interns, through: :batch

	delegate_missing_to :account
end
