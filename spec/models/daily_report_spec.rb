require 'rails_helper'

RSpec.describe DailyReport do

	context "Section Report" do
		it "must exists" do
			daily_report = build(:daily_report, section_report: nil)
			expect(daily_report.save).to be_falsey
		end

		it "association exists" do
			daily_report = create(:daily_report)
			expect(daily_report.section_report).to be_instance_of(SectionReport)
		end
	end

	context "date" do
		it "must exits" do
			daily_report = build(:daily_report, date: nil)
			daily_report.validate

			expect(daily_report.errors).to include(:date)
		end
	end

	context "progress" do
		it "must present" do
			daily_report = build(:daily_report, progress: nil)
			daily_report.validate

			expect(daily_report.errors).to include(:progress)
		end

		it "length must be greater than 24" do
			daily_report = build(:daily_report, progress: "short")
			daily_report.validate

			expect(daily_report.errors).to include(:progress)
		end
	end

	context "feedback" do
		it "can be nil" do
			daily_report = build(:daily_report, feedback: nil)
			expect(daily_report.save).to be_truthy
		end

		it "length should be greater than 5 when present" do
			daily_report = build(:daily_report, feedback: "Gud")
			daily_report.validate

			expect(daily_report.errors).to include(:feedback)
		end
	end

	context "status" do
		it "only accepts two values" do
			expect{ build(:daily_report, status: "troubleshoot") }.to raise_error(ArgumentError)
																		  .with_message(/is not a valid status/)

			daily_report = create(:daily_report)
			daily_report.ongoing!
			expect(daily_report.validate).to be_truthy

			daily_report.completed!
			expect(daily_report.validate).to be_truthy
		end
	end

	it "is deleted with section report" do
		section_report = create(:section_report)
		create(:daily_report, section_report: section_report)

		expect(DailyReport.where(section_report: section_report)).not_to be_empty
		section_report.destroy

		expect(DailyReport.where(section_report: section_report)).to be_empty
	end

end