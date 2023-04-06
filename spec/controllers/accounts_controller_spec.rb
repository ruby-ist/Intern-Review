require 'rails_helper'

RSpec.describe Api::AccountsController do
	render_views

	let(:intern) { create(:intern) }
	let(:trainer) { create(:trainer) }
	let(:admin_user) { create(:admin_user) }

	let(:intern_account) { create(:account, accountable: intern) }
	let(:trainer_account) { create(:account, accountable: trainer) }
	let(:admin_user_account) { create(:account, accountable: admin_user) }

	let(:intern_token) { create(:doorkeeper_access_token, resource_owner_id: intern_account.id) }
	let(:trainer_token) { create(:doorkeeper_access_token, resource_owner_id: trainer_account.id) }
	let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }

	describe 'GET /api/account/:id' do

		it "requires authentication" do
			get :show, params: {
				id: intern_account.id,
				format: :json
			}
			expect(response).to have_http_status(:unauthorized)
		end

		context "intern" do
			it "can not visit other intern account" do
				account = create(:account, :for_intern)
				get :show, params: {
					id: account.id,
					access_token: intern_token.token,
					format: :json
				}
				expect(response).to have_http_status(:forbidden)
			end

			it "can only visit their account" do
				get :show, params: {
					id: intern_account.id,
					access_token: intern_token.token,
					format: :json
				}
				expect(response).to have_http_status(:ok)
			end

			it "can visit trainer accounts" do
				get :show, params: {
					id: trainer_account.id,
					access_token: intern_token.token,
					format: :json
				}
				expect(response).to have_http_status(:forbidden)
			end

			it "can visit admin user accounts" do
				get :show, params: {
					id: admin_user_account.id,
					access_token: intern_token.token,
					format: :json
				}
				expect(response).to have_http_status(:forbidden)
			end

			context "should have" do
				before do
					get :show, params: {
						id: intern_account.id,
						access_token: intern_token.token,
						format: :json
					}
				end

				it "account details" do
					keys = Account.attribute_names && json_response.keys
					keys.delete 'id'
					expect(keys).not_to be_empty
				end

				%w[ batch courses trainers section_reports reviews].each do |attribute|
					it attribute do
						expect(json_response).to include attribute
					end
				end

			end
		end

		context "trainer" do
			it "can visit intern account" do
				get :show, params: {
					id: intern_account.id,
					access_token: trainer_token.token,
					format: :json
				}

				expect(response).to have_http_status(:ok)
			end

			it "cannot visit other trainers account" do
				account = create(:account, :for_trainer)
				get :show, params: {
					id: account.id,
					access_token: trainer_token.token,
					format: :json
				}

				expect(response).to have_http_status(:forbidden)
			end

			it "cannot visit admin user account" do
				get :show, params: {
					id: admin_user_account.id,
					access_token: trainer_token.token,
					format: :json
				}

				expect(response).to have_http_status(:forbidden)
			end

			context "should have" do
				before do
					get :show, params: {
						id: trainer_account.id,
						access_token: trainer_token.token,
						format: :json
					}
				end

				it "account details" do
					keys = Account.attribute_names && json_response.keys
					keys.delete 'id'
					expect(keys).not_to be_empty
				end

				%w[ batch course interns ].each do |attribute|
					it attribute do
						expect(json_response).to include attribute
					end
				end
			end
		end

		context 'admin user' do
			it "can visit interns account" do
				get :show, params: {
					id: intern_account.id,
					access_token: admin_user_token.token,
					format: :json
				}

				expect(response).to have_http_status(:ok)
			end

			it "can visit other trainers account" do
				get :show, params: {
					id: trainer_account.id,
					access_token: admin_user_token.token,
					format: :json
				}

				expect(response).to have_http_status(:ok)
			end

			context "should have" do
				before do
					get :show, params: {
						id: admin_user_account.id,
						access_token: admin_user_token.token,
						format: :json
					}
				end

				it "account details" do
					keys = Account.attribute_names && json_response.keys
					keys.delete 'id'
					expect(keys).not_to be_empty
				end

				%w[ batches reviews ].each do |attribute|
					it attribute do
						expect(json_response).to include attribute
					end
				end
			end
		end
	end

	describe '/account/update' do
		it "requires authentication" do
			put :update, params: {
				format: :json
			}
			expect(response).to have_http_status(:unauthorized)
		end

		it "checks for validation" do
			put :update, params: {
				access_token: intern_token.token,
				format: :json,
				account: {
					avatar_url: "sfskfjnsfkj"
				}
			}
			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response["errors"]).to include("avatar_url")
		end

		it "updates name and avatar_url" do
			put :update, params: {
				access_token: intern_token.token,
				format: :json,
				account: {
					name: "Srira",
					avatar_url: "https://google.com"
				}
			}
			expect(response).to have_http_status(:ok)
			expect(json_response["name"]).to eq "Srira"
			expect(json_response["avatar_url"]).to eq "https://google.com"
		end
	end
end