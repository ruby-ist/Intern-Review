class Course < ApplicationRecord
	validates :title, presence: true, length: {minimum: 3}
	validates :duration, presence: true, numericality: {only_integer: true }

	after_validation :blank_check

	def blank_check
		if image_url.blank?
			self.image_url = nil
		end
	end

end
