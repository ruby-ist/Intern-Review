class Account < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
		   :recoverable, :rememberable, :validatable

	validates :name, presence: true
	validates :avatar_url, format: {with: URI::regexp(%w{http https})}, allow_nil: true

	belongs_to :accountable, polymorphic: true
	has_many :courses

	before_validation :blank_check
	def blank_check
		if avatar_url.blank?
			self.avatar_url = nil
		end
	end

	def method_missing(method)
		if %i(intern? admin? trainer?).include? method
			accountable_type.inquiry.send(method.capitalize)
		else
			super
		end
	end

end