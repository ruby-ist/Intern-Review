FactoryBot.define do
	factory :daily_report do
		sequence :date do |n|
			Date.today - 31 + n
		end
		progress { "Learning Test Driven Development" }
		feedback { "Not fast enough, complete it sooner" }
		status { "completed" }

		section_report
	end
end
