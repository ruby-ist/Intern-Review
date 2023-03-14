class Account < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
		   :recoverable, :rememberable, :validatable

	validates :name, presence: true
	validates :avatar_url, format: {with: URI::regexp(%w{http https})}, allow_nil: true

end
