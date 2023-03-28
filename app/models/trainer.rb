class Trainer < ApplicationRecord
	belongs_to :course
	belongs_to :batch
	has_one :account, as: :accountable, dependent: :destroy
	accepts_nested_attributes_for :account

	has_many :interns, through: :batch
	has_many :daily_reports, through: :interns

	delegate_missing_to :account
end
