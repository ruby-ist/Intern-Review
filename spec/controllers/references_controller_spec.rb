require 'rails_helper'

describe Api::ReferencesController do
	render_views

	let(:intern) { create(:intern) }
	let(:trainer) { create(:trainer) }

	let(:intern_account) { create(:account, accountable: intern) }
	let(:trainer_account) { create(:account, accountable: trainer) }

	let(:intern_token) { create(:doorkeeper_access_token, resource_owner_id: intern_account.id) }
	let(:trainer_token) { create(:doorkeeper_access_token, resource_owner_id: trainer_account.id) }
	let(:section) { create(:section) }

	describe 'POST /api/sections/:section_id/references' do

		it "requires authentication" do
			post :create, params: {
				section_id: section.id,
				format: :json
			}
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to create it" do
			post :create, params: {
				section_id: section.id,
				access_token: intern_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "checks for validations" do
			post :create, params: {
				section_id: section.id,
				access_token: trainer_token.token,
				format: :json,
				reference: {
					url: ''
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('url')
		end

		it "returns a created section" do
			attr = attributes_for(:reference)

			post :create, params: {
				section_id: section.id,
				access_token: trainer_token.token,
				format: :json,
				reference: attr
			}
			expect(response).to have_http_status(:created)
			expect(json_response['section_id']).to eq section.id

			keys = Reference.attribute_names && json_response.keys
			keys.delete "id"

			expect(keys).not_to be_empty
		end

	end

	describe 'PUT /api/references/:id' do

		let(:reference) { create(:reference, section:) }

		it "requires authentication" do
			put :update, params: { id: reference.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to update it" do
			put :update, params: { id: reference.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should check validations" do
			put :update, params: {
				id: reference.id,
				reference: {
					url: 'google'
				},
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('url')
		end

		it "should update the reference" do
			new_url = 'https://chat.openai.com'
			put :update, params: {
				id: reference.id,
				reference: {
					url: new_url
				},
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response['link']).to eq new_url
		end

	end

	describe 'DELETE /api/references/:id' do

		let(:reference) { create(:reference, section:) }

		it "requires authentication" do
			delete :destroy, params: { id: reference.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to delete it" do
			delete :destroy, params: { id: reference.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "deletes the reference" do
			delete :destroy, params: { id: reference.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:no_content)
			expect(section.references).not_to include(reference)
		end

	end
end