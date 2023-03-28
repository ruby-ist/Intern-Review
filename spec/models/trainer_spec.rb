require 'rails_helper'

RSpec.describe Trainer do
	
	context "batch" do
		it "must exists" do
			trainer = build(:trainer, batch: nil)
			trainer.validate

			expect(trainer.errors).to include(:batch)
		end

		it "association exists" do
			trainer = create(:trainer)
			expect(trainer.batch).to be_instance_of(Batch)
		end
	end

	context "course" do
		it "must exists" do
			trainer = build(:trainer, course: nil)
			trainer.validate

			expect(trainer.errors).to include(:course)
		end

		it "association exists" do
			trainer = create(:trainer)
			expect(trainer.course).to be_instance_of(Course)
		end
	end

	context "has many" do
		[:interns, :daily_reports].each do |sym|
			it sym.to_s.humanize do
				association = Trainer.reflect_on_association(sym).macro
				expect(association).to be(:has_many)
			end
		end
	end

	it "has one account" do
		association = Trainer.reflect_on_association(:account).macro
		expect(association).to be(:has_one)
	end

	it "delegates missing to Account" do
		trainer = create(:trainer)
		create(:account, accountable: trainer)
		attrs = attributes_for(:account)
		attrs.each do |key, _|
			expect(trainer).to respond_to key
		end
	end

	it "accepts attributes for account" do
		attr = attributes_for(:trainer)
		attr[:account_attributes] = attributes_for(:account)

		trainer = Trainer.create(attr)
		expect(trainer.account).to be_instance_of(Account)
		expect(trainer.account).to have_attributes(attr[:account_attributes])
	end
	
end