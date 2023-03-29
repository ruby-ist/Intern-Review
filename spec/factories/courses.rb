FactoryBot.define do
	factory :course do
		sequence :title do |n|
			"test_course_#{n}"
		end
		description { "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }
		duration { 31 }
		account { nil }

		factory :accounted_course do
			account factory: :account, strategy: :build
		end
	end
end
