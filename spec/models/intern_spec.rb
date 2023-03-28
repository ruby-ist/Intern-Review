require 'rails_helper'

RSpec.describe Intern do

	context "batch" do
		it "must exists" do
			intern = build(:intern, batch: nil)
			intern.validate

			expect(intern.errors).to include(:batch)
		end

		it "association exists" do
			intern = create(:intern)
			expect(intern.batch).to be_instance_of(Batch)
		end
	end

	context "technology" do
		it "must present" do
			intern = build(:intern, technology: nil)
			intern.validate

			expect(intern.errors).to include(:technology)
		end
	end

	context "has many" do
		[:trainers, :course_reports, :section_reports, :reviews, :courses, :daily_reports].each do |sym|
			it sym.to_s.humanize do
				association = Intern.reflect_on_association(sym).macro
				expect(association).to be(:has_many)
			end
		end
	end

	it "has one account" do
		association = Intern.reflect_on_association(:account).macro
		expect(association).to be(:has_one)
	end

	it "delegates missing to Account" do
		intern = create(:intern)
		create(:account, accountable: intern)
		attrs = attributes_for(:account)
		attrs.each do |key, _|
			expect(intern).to respond_to key
		end
	end

	it "accepts attributes for account" do
		attr = attributes_for(:intern)
		attr[:account_attributes] = attributes_for(:account)

		intern = Intern.create(attr)
		expect(intern.account).to be_instance_of(Account)
		expect(intern.account).to have_attributes(attr[:account_attributes])
	end

end