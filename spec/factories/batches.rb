FactoryBot.define do
	factory :batch do
		sequence :name do |n|
			"Team Testing #{n}"
		end
		admin_user factory: :admin_user, strategy: :build
	end
end
