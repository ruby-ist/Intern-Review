require 'rails_helper'

RSpec.describe Review do
	context "Admin User" do
		it "id must exist" do
			review = build(:review, admin_user: nil)
			expect(review.save).to be_falsey
		end

		it "association exists" do
			review = create(:review)
			expect(review.admin_user).to be_instance_of(AdminUser)
		end
	end

	context "course report" do
		it "id must exist" do
			review = build(:review, course_report: nil)
			expect(review.save).to be_falsey
		end

		it "association exists" do
			review = create(:review)
			expect(review.course_report).to be_instance_of(CourseReport)
		end
	end

	context "feedback" do
		it "length should be greater than 30" do
			review = build(:review, feedback: "Good")
			review.validate
			expect(review.errors).to include(:feedback)
		end
	end

	context "has one" do
		it "intern" do
			association = Review.reflect_on_association(:intern).macro
			expect(association).to be(:has_one)
		end

		it "course" do
			association = Review.reflect_on_association(:course).macro
			expect(association).to be(:has_one)
		end
	end

	it "is deleted with course" do
		course = create(:accounted_course)
		course_report = create(:course_report, course: course)
		create(:review, course_report: course_report)

		expect(Review.find_by(course_report: )).not_to be_nil
		course.destroy
		expect(Review.find_by(course_report: )).to be_nil
	end
end