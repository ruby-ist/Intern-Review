FactoryBot.define do
	factory :review do
		feedback { "sed viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis a cras semper auctor" }
		course_report
		admin_user factory: :admin_user, strategy: :build

	end
end
