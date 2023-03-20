class Batch < ApplicationRecord
	validates :name, uniqueness: {message: "There is already a team exists with that name!"}

	belongs_to :admin
	has_many :interns
	has_many :trainers

	enum :status => {active: 0, inactive: 1}
end