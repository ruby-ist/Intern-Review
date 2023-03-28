require 'rails_helper'

RSpec.describe SectionReport do

	context "Section" do
		it "id must exist" do
			report = build(:section_report, section: nil)
			expect(report.save).to be_falsey
		end

		it "association exists" do
			report = create(:section_report)
			expect(report.section).to be_instance_of(Section)
		end
	end

	context "Intern" do
		it "must exists" do
			report = build(:section_report, intern: nil)
			expect(report.save).to be_falsey
		end

		it "association exists" do
			report = create(:section_report)
			expect(report.intern).to be_instance_of(Intern)
		end
	end

	context "status" do
		it "only accepts two values" do
			expect{ build(:section_report, status: "troubleshoot") }.to raise_error(ArgumentError)
																		  .with_message(/is not a valid status/)

			report = create(:section_report)
			report.ongoing!
			expect(report.validate).to be_truthy

			report.completed!
			expect(report.validate).to be_truthy
		end
	end

	context "has many" do
		it "DailyReports" do
			association = SectionReport.reflect_on_association(:daily_reports).macro
			expect(association).to be(:has_many)
		end
	end

	it "is deleted with Section" do
		section = create(:section)
		create(:section_report, section: section)

		expect(SectionReport.where(section: section)).not_to be_empty
		section.destroy

		expect(SectionReport.where(section: section)).to be_empty
	end
	
end
