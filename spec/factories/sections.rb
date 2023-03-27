FactoryBot.define do
	factory :section do
		title { "An exciting title" }
		context { "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Faucibus scelerisque eleifend donec pretium vulputate sapien nec sagittis aliquam. Rutrum tellus pellentesque eu tincidunt." }
		days_required { "3" }
		course factory: :accounted_course

		factory :independent_section do
			course { nil }
		end
	end
end
