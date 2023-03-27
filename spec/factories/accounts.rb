FactoryBot.define do
	factory :account do
		name { "Tester" }
		email { "tester@rently.com" }
		password { "1234567" }
		password_confirmation { "1234567" }

		for_admin_user

		trait :for_admin_user do
			association :accountable, factory: :admin_user
		end

		trait :for_intern do
			association :accountable, factory: :intern
		end

		trait :for_trainer do
			association :accountable, factory: :trainer
		end

	end

	factory :admin_user

	factory :trainer do
		batch
	end

	factory :intern do
		technology {"Ruby on Rails"}
		batch
	end
end
