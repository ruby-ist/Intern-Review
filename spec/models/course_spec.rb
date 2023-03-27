require 'rails_helper'

RSpec.describe Course do

	context "account" do
		it "should exist" do
			course = build(:course)
			expect(course.save).to be_falsey

			course = build(:accounted_course)
			expect(course.save).to be_truthy
		end
	end

	context "title" do
		it "should be length greater than 3" do
			course = build(:accounted_course, title: "")
			course.validate

			expect(course.errors).to include(:title)

			course.title = "an"
			course.validate

			expect(course.errors).to include(:title)

			course.title = "end"
			course.validate
			expect(course.errors).not_to include(:title)
		end

		it "should be unique" do
			course_1 = build(:accounted_course, title: "Ruby")
			course_1.save
			course_2 = build(:accounted_course, title: "Ruby")
			course_2.save

			expect(course_2.errors).to include(:title)
		end
	end

	context "duration" do
		it "should exist" do
			course = build(:course, duration: nil)
			course.validate

			expect(course.errors).to include(:duration)
		end

		it "must be in 1 to 90" do
			course = build(:accounted_course, duration: -10)
			course.validate

			expect(course.errors).to include(:duration)

			course.duration = 120
			course.validate

			expect(course.errors).to include(:duration)

			course.duration = 45
			course.validate

			expect(course.errors).not_to include(:duration)
		end

		it "must be an integer" do
			course = build(:accounted_course, duration: "hi")
			course.validate

			expect(course.errors).to include(:duration)
		end
	end

	context "image_url" do
		it "fallbacks to nil if value is blank" do
			course = build(:accounted_course, image_url: "")
			course.validate

			expect(course.image_url).to be_nil
		end

		it "should be a valid url" do
			course = build(:accounted_course, image_url: "this is an url")
			course.validate

			expect(course.errors).to include(:image_url)

			course.image_url = "https://google.com"
			course.validate
			expect(course.errors).not_to include(:image_url)
		end
	end

	context "associations" do
		[:sections, :trainers, :course_reports, :interns, :reviews].each do |sym|
			it "include #{sym.to_s.humanize}" do
				course = create(:accounted_course)
				expect(course).to respond_to(sym)
			end
		end
	end
end
