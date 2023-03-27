require 'rails_helper'

RSpec.describe Batch do

	context "admin user" do
		it "id must exist" do
			batch = build(:batch, admin_user: nil)
			expect(batch.save).to be_falsey
		end

		it "association exists" do
			batch = create(:batch)
			expect(batch.admin_user).to be_instance_of(AdminUser)
		end
	end

	context "name" do
		it "length should be greater than 3" do
			batch = build(:batch, name: "Tea")
			batch.validate

			expect(batch.errors).to include(:name)

			batch.name = "Team Akatsuki"
			batch.validate
			expect(batch.errors).not_to include(:name)
		end

		it "should be unique" do
			create(:batch)
			batch = build(:batch)
			batch.save

			expect(batch.errors).to include(:name)
		end
	end

	it "has many interns" do
		association = Batch.reflect_on_association(:interns).macro
		expect(association).to be(:has_many)
	end

	it "has many trainers" do
		association = Batch.reflect_on_association(:trainers).macro
		expect(association).to be(:has_many)
	end

end