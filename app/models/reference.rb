class Reference < ApplicationRecord
	validates :url, presence: true, format: { with: URI::regexp(%w{http https})}
	validates :section_id, presence: true

	belongs_to :section
end
