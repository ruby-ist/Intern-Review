class Reference < ApplicationRecord
	validates :url, presence: true, format: { with: URI::regexp(%w{http https})}

	belongs_to :section
end
