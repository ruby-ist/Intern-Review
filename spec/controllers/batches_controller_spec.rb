require 'rails_helper'

RSpec.describe Api::BatchesController do
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

	describe 'POST /api/batches' do
		it "requires authentication" do
			post :create, format: :json
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to create it" do
			post :create, params: {
				access_token: intern_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow trainers to create it" do
			post :create, params: {
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "checks for validations" do
			post :create, params: {
				access_token: admin_user_token.token,
				format: :json,
				batch: {
					feedback: ''
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('name')
		end

		it "returns a created batch" do
			attr = attributes_for(:batch)

			post :create, params: {
				access_token: admin_user_token.token,
				format: :json,
				batch: attr
			}
			expect(response).to have_http_status(:created)
			expect(json_response['admin_user_id']).to eq admin_user.id

			keys = Batch.attribute_names && json_response.keys
			keys.delete "id"

			expect(keys).not_to be_empty
		end
	end

	describe 'PUT /api/batches/:id' do
		let(:batch) { create(:batch) }

		it "requires authentication" do
			put :update, params: { id: batch.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to update it" do
			put :update, params: { id: batch.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow trainers to update it" do
			put :update, params: { id: batch.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should check validations" do
			put :update, params: {
				id: batch.id,
				batch: {
					name: ''
				},
				access_token: admin_user_token.token,
				format: :json
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('name')
		end

		it "should update the batch" do
			new_name = 'Team srira'
			put :update, params: {
				id: batch.id,
				batch: {
					name: new_name
				},
				access_token: admin_user_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response['name']).to eq new_name
		end
	end

	describe 'DELETE /api/batches/:id' do

		let(:batch) { create(:batch, admin_user:) }

		it "requires authentication" do
			delete :destroy, params: { id: batch.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to delete it" do
			delete :destroy, params: { id: batch.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow trainers to delete it" do
			delete :destroy, params: { id: batch.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "deletes the batch" do
			delete :destroy, params: { id: batch.id, access_token: admin_user_token.token, format: :json }
			expect(response).to have_http_status(:no_content)
			expect(admin_user.batches).not_to include(batch)
		end

	end

end