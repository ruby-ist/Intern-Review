class AdminUser < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable,
		   :recoverable, :rememberable, :validatable

	has_one :account, as: :accountable, dependent: :destroy
	accepts_nested_attributes_for :account

	has_many :reviews
	has_many :batches

	has_many :interns, through: :batches
	has_many :trainers, through: :batches
	has_many :daily_reports, through: :interns

	delegate_missing_to :account
end
