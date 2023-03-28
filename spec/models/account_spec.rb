require 'rails_helper'

RSpec.describe Account do

	context "accountable" do
		it "must exists" do
			account = build(:account, accountable: nil)
			expect(account.save).to be_falsey
		end
	end

	context "email" do

		it "should be present" do
			account = build(:account, email: nil)
			expect(account.save).to be_falsey
		end

		it "should be valid" do
			account = build(:account, email: "This is an email")
			account.validate
			expect(account.errors).to include(:email)
		end

		it "must be unique" do
			create(:account, email: "tester@rently.com")
			account = build(:account, email: "tester@rently.com")

			expect(account.save).to be_falsey
		end

	end

	context "password" do

		it "must match" do
			account = build(:account, password: "password", password_confirmation: "Password")
			account.validate

			expect(account.errors).to include(:password_confirmation)
		end

		it "length must be greater than six" do
			account = build(:account, password: "1234", password_confirmation: "1234")
			account.validate

			expect(account.errors).to include(:password)
		end

	end

	context "name" do
		it "must present" do
			account = build(:account, name: nil)
			account.validate

			expect(account.errors).to include(:name)
		end
	end

	context "avatar URL" do
		it "fallbacks to nil if value is blank" do
			account = build(:account, avatar_url: "")
			account.validate

			expect(account.avatar_url).to be_nil
		end

		it "should be a valid url" do
			account = build(:account, avatar_url: "this is an url")
			account.validate

			expect(account.errors).to include(:avatar_url)

			account.avatar_url = "https://google.com"
			account.validate
			expect(account.errors).not_to include(:avatar_url)
		end
	end

	context "has many" do
		it "courses" do
			association = Account.reflect_on_association(:courses).macro
			expect(association).to be(:has_many)
		end

		it "access tokens" do
			association = Account.reflect_on_association(:access_tokens).macro
			expect(association).to be(:has_many)
		end
	end

	[:intern, :trainer, :admin_user].each do |user|
		it "is deleted with #{user.to_s.humanize}" do
			accountable = create(user)
			create(:account, accountable: accountable)

			expect(Account.where(accountable: accountable)).not_to be_empty
			accountable.destroy

			expect(Account.where(accountable: accountable)).to be_empty
		end
	end

	it "can authenticate" do
		expect(Account).to respond_to(:authenticate!)
	end

	context "returns boolean for" do
		it "intern?" do
			intern = create(:intern)
			account = create(:account, accountable: intern)

			expect(account.intern?).to be true
			expect(account.trainer?).to be false
			expect(account.admin_user?).to be false
		end

		it "trainer?" do
			trainer = create(:trainer)
			account = create(:account, accountable: trainer)

			expect(account.intern?).to be false
			expect(account.trainer?).to be true
			expect(account.admin_user?).to be false
		end

		it "intern?" do
			admin_user = create(:admin_user)
			account = create(:account, accountable: admin_user)

			expect(account.intern?).to be false
			expect(account.trainer?).to be false
			expect(account.admin_user?).to be true
		end
	end

end