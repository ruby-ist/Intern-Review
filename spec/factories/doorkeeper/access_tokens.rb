FactoryBot.define do
	factory :doorkeeper_access_token, class: 'Doorkeeper::AccessToken' do
		expires_in { 3600 }
		scopes { "" }
	end
end
