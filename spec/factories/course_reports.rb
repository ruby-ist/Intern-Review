FactoryBot.define do
	factory :course_report do
		intern
		course factory: :accounted_course
	end
end
