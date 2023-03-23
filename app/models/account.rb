class Account < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
		   :recoverable, :rememberable, :validatable

	class << self
		def authenticate!(email, password)
			account = find_by(email: )
			account if account&.valid_password? password
		end
	end

	validates :name, presence: true
	validates :avatar_url, format: { with: URI::regexp(%w{http https}) }, allow_nil: true

	belongs_to :accountable, polymorphic: true, inverse_of: :account
	has_many :courses

	has_many :access_grants,
			 class_name: 'Doorkeeper::AccessGrant',
			 foreign_key: :resource_owner_id,
			 dependent: :delete_all # or :destroy if you need callbacks

	has_many :access_tokens,
			 class_name: 'Doorkeeper::AccessToken',
			 foreign_key: :resource_owner_id,
			 dependent: :delete_all # or :destroy if you need callbacks

	before_validation :blank_check
	def blank_check
		if avatar_url.blank?
			self.avatar_url = nil
		end
	end

	def method_missing(method)
		if %i(intern? admin_user? trainer?).include? method
			accountable_type.underscore.inquiry.send(method)
		else
			super
		end
	end

end
