require 'rails_helper'

RSpec.describe Api::Accounts::PasswordsController do

	let(:account) { create(:account, password: "1234567") }
	let(:token) { create(:doorkeeper_access_token, resource_owner_id: account.id) }

	describe "PATCH /api/accounts/password" do
		it "requires authentication" do
			patch :update
			expect(response).to have_http_status(:unauthorized)
		end

		it "requires current passwords" do
			patch :update, params: {
				format: :json,
				access_token: token.token
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include("password")
		end

		it "checks for password validation" do
			patch :update, params: {
				format: :json,
				access_token: token.token,
				current_password: "1234567",
				account: {
					password: "123",
					password_confirmation: "123"
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include("password")
		end

		it "should match the password confirmation" do
			patch :update, params: {
				format: :json,
				access_token: token.token,
				current_password: "1234567",
				account: {
					password: "1233438",
					password_confirmation: "12308786"
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include("password_confirmation")
		end

		it "updates the password" do
			patch :update, params: {
				format: :json,
				access_token: token.token,
				current_password: "1234567",
				account: {
					password: "password",
					password_confirmation: "password"
				}
			}

			expect(response).to have_http_status(:ok)
			expect(account.reload.valid_password?("password")).to be true
		end

		it "does not update other attributes" do
			patch :update, params: {
				format: :json,
				access_token: token.token,
				current_password: "1234567",
				account: {
					email: "new-mail@gmail.com",
					password: "password",
					password_confirmation: "password"
				}
			}

			expect(response).to have_http_status(:ok)
			expect(account.reload.email).not_to eq "new-mail@gmail.com"
		end
	end

end
