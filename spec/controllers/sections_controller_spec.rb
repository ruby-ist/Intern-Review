require 'rails_helper'

RSpec.describe Api::SectionsController do
	render_views

	let(:intern) { create(:intern) }
	let(:trainer) { create(:trainer) }

	let(:intern_account) { create(:account, accountable: intern) }
	let(:trainer_account) { create(:account, accountable: trainer) }

	let(:intern_token) { create(:doorkeeper_access_token, resource_owner_id: intern_account.id) }
	let(:trainer_token) { create(:doorkeeper_access_token, resource_owner_id: trainer_account.id) }
	let(:course) { create(:accounted_course) }

	describe 'POST /api/courses/:course_id/sections' do

		it "requires authentication" do
			post :create, params: {
				course_id: course.id,
				format: :json
			}
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to create it" do
			post :create, params: {
				course_id: course.id,
				access_token: intern_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "checks for validations" do
			post :create, params: {
				course_id: course.id,
				access_token: trainer_token.token,
				format: :json,
				section: {
					title: '',
					days_required: '',
					context: ''
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include("title", "days_required", 'context')
		end

		it "returns a created section" do
			attr = attributes_for(:section)

			post :create, params: {
				course_id: course.id,
				access_token: trainer_token.token,
				format: :json,
				section: attr
			}
			expect(response).to have_http_status(:created)
			expect(json_response['course_id']).to eq course.id

			keys = Section.attribute_names && json_response.keys
			keys.delete "id"

			expect(keys).not_to be_empty
		end

	end

	describe 'GET /api/section/:id' do
		let(:section) { create(:section, course: course) }

		context "intern" do
			it "can visit section if enrolled in course" do
				create(:course_report, course: course, intern: intern)
				get :show, params: {
					id: section.id,
					access_token: intern_token.token,
					format: :json
				}
				expect(response).to have_http_status(:ok)
			end

			it "can not visit all section" do
				get :show, params: {
					id: section.id,
					access_token: intern_token.token,
					format: :json
				}
				expect(response).to have_http_status(:forbidden)
			end
		end

		it "returns the correct section as json" do
			get :show, params: {
				id: section.id,
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response["id"]).to eq section.id
		end

		it "returns references" do
			create_list(:reference, 3, section: section)
			get :show, params: {
				id: section.id,
				access_token: trainer_token.token,
				format: :json
			}

			expect(json_response).to include("references")
			expect(json_response['references']).not_to be_empty
		end

		it "returns daily reports" do
			create(:course_report, course:, intern:)
			section_report = create(:section_report, intern: , section:)
			create_list(:daily_report, 5, section_report: )

			get :show, params: {
				id: section.id,
				access_token: intern_token.token,
				format: :json
			}

			expect(json_response).to include("daily_reports")
			expect(json_response['daily_reports']).not_to be_empty
		end
	end

	describe 'PUT /api/sections/:id' do
		let(:section) { create(:section, course:) }

		it "requires authentication" do
			put :update, params: { id: section.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to update it" do
			put :update, params: { id: section.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should check validations" do
			put :update, params: {
				id: section.id,
				section: {
					title: ''
				},
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('title')
		end

		it "should update the section" do
			new_title = "updated title"
			put :update, params: {
				id: section.id,
				section: {
					title: new_title
				},
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response['title']).to eq new_title
		end
	end

	describe 'DELETE /api/sections/:id' do
		let(:section) { create(:section, course:) }

		it "requires authentication" do
			delete :destroy, params: { id: section.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to delete it" do
			delete :destroy, params: { id: section.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "deletes the course" do
			delete :destroy, params: { id: section.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:no_content)
			expect(course.sections).not_to include(section)
		end
	end
end