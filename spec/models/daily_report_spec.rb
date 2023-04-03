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
			expect { build(:daily_report, status: "troubleshoot") }.to raise_error(ArgumentError)
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

	context "for first report of the section" do
		let(:section_report) { create(:section_report) }

		it "has no daily reports before" do
			expect(section_report.daily_reports).to be_empty
		end

		context "on creation" do
			context "ongoing report" do
				it "should update start date" do
					daily_report = create(:daily_report, section_report: section_report, status: "ongoing")
					expect(section_report.start_date).to eql(daily_report.date)
					expect(section_report.end_date).to be nil
				end
			end

			context "completed report" do
				let!(:daily_report) { create(:daily_report, section_report: section_report, status: "completed") }

				it "should update section report start date" do
					expect(section_report.start_date).to eql(daily_report.date)
				end

				it "should update section report end date" do
					expect(section_report.end_date).to eql(daily_report.date)
				end

				it "should update section report status" do
					expect(section_report.completed?).to be true
				end
			end
		end

		context "on update" do
			let(:daily_report) { create(:daily_report, section_report: section_report, date: Date.today) }

			context "report date" do
				it "should match section report start date" do
					daily_report.update(date: Date.yesterday)
					expect(section_report.start_date).to eql Date.yesterday
				end
			end
		end

		context "on deleting" do
			context "only report" do
				it "should update section report dates" do
					daily_report = create(:daily_report, section_report: section_report, status: "completed")
					expect(section_report.start_date).not_to be_nil
					expect(section_report.end_date).not_to be_nil
					expect(section_report.completed?).to be true

					daily_report.destroy
					expect(section_report.start_date).to be_nil
					expect(section_report.end_date).to be_nil
					expect(section_report.ongoing?).to be true
				end
			end

			context "first report" do
				it "next report date should become section start date" do
					create_list(:daily_report, 2, section_report: section_report)
					first_report = section_report.daily_reports.first
					second_report = section_report.daily_reports.second

					expect(section_report.start_date).to eql(first_report.date)
					first_report.destroy

					expect(section_report.start_date).to eql(second_report.date)
				end
			end
		end
	end

	context "for last report of the section" do
		let!(:section_report) { create(:section_report) }
		let!(:reports) { create_list(:daily_report, 4, section_report: section_report, status: "ongoing") }

		context "on creation of" do
			context "completed report" do
				let!(:daily_report) { create(:daily_report, section_report: section_report, status: "completed") }


				it "should not change section report start date" do
					expect(section_report.start_date).not_to eql(daily_report.date)
				end

				it "should update section report end date" do
					expect(section_report.end_date).to eql(daily_report.date)
				end

				it "should update section report status" do
					expect(section_report.completed?).to be true
				end
			end
		end

		context "on updating" do
			context "status" do
				context "completed report" do
					let!(:daily_report) { section_report.daily_reports.order_by_date.first }

					before do
						expect(section_report.end_date).to be_nil
						expect(section_report.ongoing?).to be true
						daily_report.update(status: "completed")
					end


					it "should update section report end date" do
						expect(section_report.end_date).to eql(daily_report.date)
					end

					it "should update section report status" do
						expect(section_report.completed?).to be true
					end
				end

				context "ongoing report" do
					let!(:daily_report) {
						create(:daily_report, section_report: section_report, status: "completed")
						section_report.daily_reports.order_by_date.first
					}

					before do
						expect(section_report.end_date).not_to be_nil
						expect(section_report.completed?).to be true
						daily_report.update(status: "ongoing")
					end

					it "should update section report end date" do
						expect(section_report.end_date).to be_nil
					end

					it "should update section report status" do
						expect(section_report.ongoing?).to be true
					end
				end
			end

			context "date of last completed report" do
				let!(:daily_report) {
					create(:daily_report, section_report: section_report, status: "completed")
					section_report.daily_reports.order_by_date.first
				}

				before do
					expect(section_report.end_date).not_to be_nil
					expect(section_report.completed?).to be true
					daily_report.update(date: Date.today + 1.month)
				end

				it "should update section report end date" do
					expect(section_report.end_date).to eql(Date.today + 1.month)
				end
			end
		end

		context "on deleting last completed report" do
			let!(:daily_report) { create(:daily_report, section_report: section_report, status: "completed") }

			before do
				expect(section_report.end_date).to eql(daily_report.date)
				expect(section_report.completed?).to be true
				daily_report.destroy
			end

			it "should update section end date" do
				expect(section_report.end_date).to be_nil
			end

			it "should update section status" do
				expect(section_report.ongoing?).to be true
			end
		end
	end

end