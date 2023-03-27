FactoryBot.define do
	factory :daily_report do
		date { "27-03-2023" }
		progress { "Learning Test Driven Development" }
		feedback { "Not fast enough" }
		status { "Completed" }

		section_report
	end
end
