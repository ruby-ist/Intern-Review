require 'rails_helper'

describe Api::CoursesController do
	render_views

	let(:intern) { create(:intern) }
	let(:trainer) { create(:trainer) }

	let(:intern_account) { create(:account, accountable: intern) }
	let(:trainer_account) { create(:account, accountable: trainer) }

	let(:intern_token) { create(:doorkeeper_access_token, resource_owner_id: intern_account.id) }
	let(:trainer_token) { create(:doorkeeper_access_token, resource_owner_id: trainer_account.id) }

	describe 'GET /api/courses' do
		it "should need access token" do
			get :index, format: :json
			expect(response).to have_http_status(:unauthorized)
		end

		it "should return list of all courses" do
			count = 5
			create_list(:accounted_course, count)
			get :index, params: { access_token: trainer_token.token, format: :json }

			expect(response).to have_http_status(:ok)
			expect(json_response.count).to eq Course.all.count
		end

		it "should return only enrolled courses for intern" do
			count = 5
			enrolling_count = 3
			courses = create_list(:accounted_course, count)
			courses.take(enrolling_count).each do |course|
				create(:course_report, intern: intern, course: course)
			end

			get :index, params: { access_token: intern_token.token, format: :json }

			expect(response).to have_http_status(:ok)
			expect(Course.all.count).to eq count
			expect(json_response.count).to eq enrolling_count
		end
	end

	describe 'POST /api/courses' do

		it "requires authentication" do
			post :create, format: :json
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to create it" do
			post :create, params: { access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "checks for validations" do
			post :create, params: {
				access_token: trainer_token.token,
				format: :json,
				course: {
					title: '',
					duration: ''
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include("title", "duration")
		end

		it "returns a created course" do
			attr = attributes_for(:course)

			post :create, params: {
				access_token: trainer_token.token,
				format: :json,
				course: attr
			}
			expect(response).to have_http_status(:created)

			keys = Course.attribute_names && json_response.keys
			keys.delete "id"

			expect(keys).not_to be_empty
		end
	end

	describe 'GET /api/courses/:id' do
		context "intern" do
			it "can only visit enrolled courses" do
				courses = create_list(:accounted_course, 2)
				create(:course_report, intern: intern, course: courses.first)

				get :show, params: {
					id: courses.first.id,
					access_token: intern_token.token,
					format: :json
				}

				expect(response).to have_http_status(:ok)

				get :show, params: {
					id: courses.second.id,
					access_token: intern_token.token,
					format: :json
				}

				expect(response).to have_http_status(:forbidden)
			end
		end

		it "returns the correct course as json" do
			course = create(:accounted_course)

			get :show, params: {
				id: course.id,
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response["id"]).to eq course.id
		end

		it "also returns sections" do
			course = create(:accounted_course)
			create_list(:section, 3, course: course)

			get :show, params: {
				id: course.id,
				access_token: trainer_token.token,
				format: :json
			}

			expect(json_response).to include("sections")
			expect(json_response['sections']).not_to be_empty
		end
	end

	describe 'PUT /api/courses/:id' do
		let(:course) { create(:accounted_course) }

		it "requires authentication" do
			put :update, params: { id: course.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to update it" do
			put :update, params: { id: course.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should check validations" do
			put :update, params: {
				id: course.id,
				course: {
					title: ''
				},
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('title')
		end

		it "should update the course" do
			new_title = "updated title"
			put :update, params: {
				id: course.id,
				course: {
					title: new_title
				},
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response['title']).to eq new_title
		end
	end

	describe 'DELETE /api/courses/:id' do
		let(:course) { create(:accounted_course) }

		it "requires authentication" do
			delete :destroy, params: { id: course.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to delete it" do
			delete :destroy, params: { id: course.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "deletes the course" do
			delete :destroy, params: { id: course.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:no_content)
			expect(Course.all).not_to include(course)
		end
	end
end
