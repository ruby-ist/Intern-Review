FactoryBot.define do
	factory :daily_report do
		date { "27-03-2023" }
		progress { "Learning Test Driven Development" }
		feedback { "Not fast enough, complete it sooner" }
		status { "completed" }

		section_report
	end
end
