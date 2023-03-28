require 'rails_helper'

RSpec.describe CourseReport do

	context "Course" do
		it "must exists" do
			report = build(:course_report, course: nil)
			expect(report.save).to be_falsey
		end

		it "association exists" do
			report = create(:course_report)
			expect(report.course).to be_instance_of(Course)
		end
	end

	context "Intern" do
		it "must exists" do
			report = build(:course_report, intern: nil)
			expect(report.save).to be_falsey
		end

		it "association exists" do
			report = create(:course_report)
			expect(report.intern).to be_instance_of(Intern)
		end
	end

	context "has one" do
		it "review" do
			association = CourseReport.reflect_on_association(:review).macro
			expect(association).to be(:has_one)
		end
	end

	it "accepts attributes for reviews" do
		attr = attributes_for(:course_report)
		attr[:review_attributes] = attributes_for(:review)

		course_report = CourseReport.create(attr)

		expect(course_report.review).to be_instance_of(Review)
		expect(course_report.review).to have_attributes(attributes_for(:review))
	end

	it "is deleted with course" do
		course = create(:accounted_course)
		create(:course_report, course: course)

		expect(CourseReport.where(course: course)).not_to be_empty
		course.destroy

		expect(CourseReport.where(course: course)).to be_empty
	end

end
