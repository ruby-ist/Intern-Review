FactoryBot.define do
	factory :batch do
		name { "Team Testing" }
		admin_user factory: :admin_user, strategy: :build
	end
end
