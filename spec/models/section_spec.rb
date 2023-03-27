require 'rails_helper'

RSpec.describe Section do

	context "course" do
		it "must exists" do
			section = build(:independent_section)
			expect(section.save).to be_falsey
		end

		it "association exists" do
			section = create(:section)
			expect(section.course).to be_instance_of(Course)
		end
	end

	context "title" do
		it "must be present" do
			section = build(:section, title: nil)
			section.validate

			expect(section.errors).to include(:title)
		end

		it "length should be greater than 3" do
			section = build(:section, title: "xy")
			section.validate

			expect(section.errors).to include(:title)

			section.title = "title"
			section.validate
			expect(section.errors).not_to include(:title)
		end
	end

	context "context" do
		it "must be present" do
			section = build(:section, context: nil)
			section.validate

			expect(section.errors).to include(:context)
		end

		it "length should be greater than 10" do
			section = build(:section, context: "context")
			section.validate

			expect(section.errors).to include(:context)

			section.context = "A valid context"
			section.validate
			expect(section.errors).not_to include(:context)
		end
	end

	context "days_required" do
		it "must be a number" do
			section = build(:section, days_required: "one")
			section.validate

			expect(section.errors).to include(:days_required)
		end

		it "should be positive" do
			section = build(:section, days_required: -1)
			section.validate

			expect(section.errors).to include(:days_required)
		end

		it "should be less than 8" do
			section = build(:section, days_required: 10)
			section.validate

			expect(section.errors).to include(:days_required)

			section.days_required = 4
			section.validate
			expect(section.errors).not_to include(:days_required)
		end
	end

	context "associations" do
		[:references, :interns, :section_reports, :daily_reports].each do |sym|
			it "include #{sym.to_s.humanize}" do
				section = create(:section)
				expect(section).to respond_to(sym)
			end
		end
	end

	it "is deleted with course" do
		course = create(:accounted_course)

		4.times do
			create(:section, course: course)
		end

		expect(Section.where(course: course).count).not_to be_zero

		course.destroy
		expect(Section.where(course: course).count).to be_zero
	end

end
