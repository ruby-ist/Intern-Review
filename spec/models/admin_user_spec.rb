require 'rails_helper'

RSpec.describe AdminUser do

	it "has one account" do
		association = AdminUser.reflect_on_association(:account).macro
		expect(association).to be(:has_one)
	end

	it "delegates missing to Account" do
		admin_user = create(:admin_user)
		create(:account, accountable: admin_user)
		attrs = attributes_for(:account)
		attrs.each do |key, _|
			expect(admin_user).to respond_to key
		end
	end

	it "accepts attributes for account" do
		attr = attributes_for(:admin_user)
		attr[:account_attributes] = attributes_for(:account)

		admin_user = AdminUser.create(attr)
		expect(admin_user.account).to be_instance_of(Account)
		expect(admin_user.account).to have_attributes(attr[:account_attributes])
	end

	context "has many" do
		[:trainers, :interns, :reviews, :daily_reports, :batches].each do |sym|
			it sym.to_s.humanize do
				association = AdminUser.reflect_on_association(sym).macro
				expect(association).to be(:has_many)
			end
		end
	end

end
