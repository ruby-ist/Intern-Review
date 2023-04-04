require 'rails_helper'

RSpec.describe Api::ReviewsController do
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
	let(:course_report) { create(:course_report) }

	describe 'POST /api/course_report/:course_report_id/reviews' do
		it "requires authentication" do
			post :create, params: {
				course_report_id: course_report.id,
				format: :json
			}
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to create it" do
			post :create, params: {
				course_report_id: course_report.id,
				access_token: intern_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow trainers to create it" do
			post :create, params: {
				course_report_id: course_report.id,
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "checks for validations" do
			post :create, params: {
				course_report_id: course_report.id,
				access_token: admin_user_token.token,
				format: :json,
				review: {
					feedback: ''
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('feedback')
		end

		it "returns a created review" do
			attr = attributes_for(:review)

			post :create, params: {
				course_report_id: course_report.id,
				access_token: admin_user_token.token,
				format: :json,
				review: attr
			}
			expect(response).to have_http_status(:created)
			expect(json_response['admin_user_id']).to eq admin_user.id
			expect(json_response).to include('intern_id', 'course_id')

			keys = Review.attribute_names && json_response.keys
			keys.delete "id"

			expect(keys).not_to be_empty
		end
	end

	describe 'PUT /api/reviews/:id' do
		let(:review) { create(:review, course_report:, admin_user:) }

		it "requires authentication" do
			put :update, params: { id: review.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to update it" do
			put :update, params: { id: review.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow trainers to update it" do
			put :update, params: { id: review.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should check validations" do
			put :update, params: {
				id: review.id,
				review: {
					feedback: ''
				},
				access_token: admin_user_token.token,
				format: :json
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('feedback')
		end

		it "should update the review" do
			new_feedback = "lsnvljsndamdnfdvkajvandljfvdaolfjknlvfn"
			put :update, params: {
				id: review.id,
				review: {
					feedback: new_feedback
				},
				access_token: admin_user_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response['review']).to eq new_feedback
		end
	end

	describe 'DELETE /api/reviews/:id' do

		let(:review) { create(:review, course_report:, admin_user: ) }

		it "requires authentication" do
			delete :destroy, params: { id: review.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to delete it" do
			delete :destroy, params: { id: review.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow trainers to delete it" do
			delete :destroy, params: { id: review.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "deletes the review" do
			delete :destroy, params: { id: review.id, access_token: admin_user_token.token, format: :json }
			expect(response).to have_http_status(:no_content)
			expect(admin_user.reviews).not_to include(review)
		end

	end

	describe 'PATCH /api/daily_report/:id/progress' do
		let(:review) { create(:review, intern: ) }

		it "requires authentication"do
			patch :update_progress, params: { id: review.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow admins to update it" do
			patch :update_progress, params: {
				id: review.id,
				access_token: admin_user_token.token,
				format: :json,
			}
			expect(response).to have_http_status(:forbidden)
		end

		it "should check for validation" do
			patch :update_progress, params: {
				id: review.id,
				access_token: intern_token.token,
				format: :json,
				review: {
					progress: 'damn',
				}
			}
			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('progress')
		end

		it "should update progress" do
			progress = "There i completed my report"
			patch :update_progress, params: {
				id: review.id,
				access_token: intern_token.token,
				format: :json,
				review: {
					progress: progress
				}
			}
			expect(response).to have_http_status(:ok)
			expect(json_response['progress']).to include progress
		end

		it "should not update other fields" do
			feedback = "sfsfsfsfsgdg"
			patch :update_progress, params: {
				id: review.id,
				access_token: intern_token.token,
				format: :json,
				review: {
					feedback: feedback
				}
			}
			expect(response).to have_http_status(:ok)
			expect(json_response['feedback']).not_to eq feedback
		end

		it "should only allow interns to update their own review" do
			review = create(:review)
			progress = "There i completed my report"
			patch :update_progress, params: {
				id: review.id,
				access_token: intern_token.token,
				format: :json,
				review: {
					progress: progress
				}
			}
			expect(response).to have_http_status(:forbidden)
		end
	end
end