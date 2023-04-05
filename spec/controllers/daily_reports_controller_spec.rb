require 'rails_helper'

RSpec.describe Api::DailyReportsController do
	render_views

	let(:admin_user) { create(:admin_user) }

	let(:batch) { create(:batch, admin_user: ) }
	let(:intern) { create(:intern, batch:) }
	let(:trainer) { create(:trainer, batch: ) }

	let(:intern_account) { create(:account, accountable: intern) }
	let(:trainer_account) { create(:account, accountable: trainer) }
	let(:admin_user_account) { create(:account, accountable: admin_user) }

	let(:intern_token) { create(:doorkeeper_access_token, resource_owner_id: intern_account.id) }
	let(:trainer_token) { create(:doorkeeper_access_token, resource_owner_id: trainer_account.id) }
	let(:admin_user_token) { create(:doorkeeper_access_token, resource_owner_id: admin_user_account.id) }

	let(:section) { create(:section) }


	describe 'GET /api/daily_reports' do
		it "requires authentication" do
			get :index, params: {
				format: :json
			}
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns" do
			get :index, params: {
				access_token: intern_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		context "for trainers" do
			it "should return all interns daily reports" do
				create_list(:intern, 3, batch:).each do |intern|
					create_list(:daily_report, 5, intern:)
					create(:daily_report, date: Date.today)
				end

				get :index, params: {
					access_token: trainer_token.token,
					format: :json,
				}
				expect(response).to have_http_status(:ok)
				expect(json_response.count).to eql trainer.daily_reports.where(date: Date.today).count

				get :index, params: {
					access_token: trainer_token.token,
					format: :json,
					date: 'all'
				}
				expect(response).to have_http_status(:ok)
				expect(json_response.count).to eql trainer.daily_reports.count
			end
		end

		context "for admin users" do
			it "should return all batches daily reports" do
				create_list(:batch, 2, admin_user:).each do |batch|
					create_list(:intern, 3, batch:).each do |intern|
						create_list(:daily_report, 2, intern:)
						create(:daily_report, date: Date.today)
					end
				end

				get :index, params: {
					access_token: admin_user_token.token,
					format: :json,
				}
				expect(response).to have_http_status(:ok)
				expect(json_response.count).to eql admin_user.daily_reports.where(date: Date.today).count

				get :index, params: {
					access_token: admin_user_token.token,
					format: :json,
					date: 'all'
				}
				expect(response).to have_http_status(:ok)
				expect(json_response.count).to eql admin_user.daily_reports.count
			end
		end
	end

	describe 'POST /api/sections/:section_id/' do

		it "requires authentication" do
			post :create, params: {
				section_id: section.id,
				format: :json
			}
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow trainers to create it" do
			post :create, params: {
				section_id: section.id,
				access_token: trainer_token.token,
				format: :json
			}

			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "checks for validations" do
			post :create, params: {
				section_id: section.id,
				access_token: intern_token.token,
				format: :json,
				daily_report: {
					date: '',
					progress: '',
					status: ''
				}
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('date', 'progress', 'date')
		end

		it "returns a created section" do
			attr = attributes_for(:daily_report)

			post :create, params: {
				section_id: section.id,
				access_token: intern_token.token,
				format: :json,
				daily_report: attr
			}
			expect(response).to have_http_status(:created)
			expect(json_response['section_id']).to eq section.id

			keys = DailyReport.attribute_names && json_response.keys
			keys.delete "id"

			expect(keys).not_to be_empty
		end

	end

	describe 'PUT /api/daily_reports/:id' do

		let(:daily_report) { create(:daily_report, section:, intern:) }

		it "requires authentication" do
			put :update, params: { id: daily_report.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow trainers to update it" do
			put :update, params: { id: daily_report.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow other interns to update it" do
			daily_report = create(:daily_report)
			put :update, params: { id: daily_report.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response['errors']).to include("intern")
		end

		it "should check validations" do
			put :update, params: {
				id: daily_report.id,
				daily_report: {
					progress: ''
				},
				access_token: intern_token.token,
				format: :json
			}

			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('progress')
		end

		it "should update the daily_report" do
			new_status = 'completed'
			put :update, params: {
				id: daily_report.id,
				daily_report: {
					status: new_status
				},
				access_token: intern_token.token,
				format: :json
			}

			expect(response).to have_http_status(:ok)
			expect(json_response['status']).to eq new_status
		end

	end

	describe 'DELETE /api/daily_reports/:id' do

		let(:daily_report) { create(:daily_report, section:, intern:) }

		it "requires authentication" do
			delete :destroy, params: { id: daily_report.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow trainers to delete it" do
			delete :destroy, params: { id: daily_report.id, access_token: trainer_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response).to include("errors")
		end

		it "should not allow other interns to destroy it" do
			daily_report = create(:daily_report)
			delete :destroy, params: { id: daily_report.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:forbidden)
			expect(json_response['errors']).to include("intern")
		end

		it "deletes the daily_report" do
			delete :destroy, params: { id: daily_report.id, access_token: intern_token.token, format: :json }
			expect(response).to have_http_status(:no_content)
			expect(section.daily_reports).not_to include(daily_report)
		end

	end

	describe 'PATCH /api/daily_report/:id/feedback' do
		let(:daily_report) { create(:daily_report, section: section) }

		it "requires authentication"do
			patch :update_feedback, params: { id: daily_report.id, format: :json }
			expect(response).to have_http_status(:unauthorized)
		end

		it "should not allow interns to update it" do
			patch :update_feedback, params: {
				id: daily_report.id,
				access_token: intern_token.token,
				format: :json,
			}
			expect(response).to have_http_status(:forbidden)
		end

		it "should check for validation" do
			patch :update_feedback, params: {
				id: daily_report.id,
				access_token: trainer_token.token,
				format: :json,
				daily_report: {
					feedback: 'damn'
				}
			}
			expect(response).to have_http_status(:unprocessable_entity)
			expect(json_response['errors']).to include('feedback')
		end

		it "should update feedback" do
			feedback = "Good work!"
			patch :update_feedback, params: {
				id: daily_report.id,
				access_token: trainer_token.token,
				format: :json,
				daily_report: {
					feedback: feedback
				}
			}
			expect(response).to have_http_status(:ok)
			expect(json_response['feedback']).to include feedback
		end

		it "should not update other fields" do
			date = Date.today
			patch :update_feedback, params: {
				id: daily_report.id,
				access_token: trainer_token.token,
				format: :json,
				daily_report: {
					date: date
				}
			}
			expect(response).to have_http_status(:ok)
			expect(json_response['date']).not_to eq date
		end

	end
end