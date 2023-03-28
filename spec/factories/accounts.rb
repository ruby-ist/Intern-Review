FactoryBot.define do
	factory :account do
		name { "Tester" }
		sequence :email do |n|
			"tester_#{n}@rently.com"
		end
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

	factory :admin_user do
		sequence :email do |n|
			"admin_#{n}@rently.com"
		end
		password { "admin_password" }
		password_confirmation { "admin_password" }
	end

	factory :trainer do
		batch
		course factory: :accounted_course
	end

	factory :intern do
		technology {"Ruby on Rails"}
		batch
	end
end
