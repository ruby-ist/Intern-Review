require 'rails_helper'

RSpec.describe Reference do
	context "section" do
		it "id must exist" do
			reference = build(:reference, section: nil)
			expect(reference.save).to be_falsey
		end

		it "association exists" do
			reference = create(:reference)
			expect(reference.section).to be_instance_of(Section)
		end
	end

	context "url" do
		it "should be present" do
			reference = build(:reference, url: nil)
			expect(reference.save).to be_falsey
		end

		it "should be valid" do
			reference = build(:reference, url: "will_it_pass_validation.com")
			reference.validate

			expect(reference.errors).to include(:url)

			reference.url = "https://google.com"
			reference.validate
			expect(reference.errors).not_to include(:url)
		end
	end

	it "is deleted with section" do
		section = create(:section)
		create(:reference, section: section)

		expect(Reference.where(section: section)).not_to be_empty

		section.destroy
		expect(Reference.where(section: section)).to be_empty
	end

	it "deleted with course" do
		course = create(:accounted_course)
		section = create(:section, course: course)
		create(:reference, section: section)

		expect(Reference.where(section: section)).not_to be_empty

		course.destroy
		expect(Reference.where(section: section)).to be_empty
	end

end
