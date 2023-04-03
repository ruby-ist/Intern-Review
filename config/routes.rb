Rails.application.routes.draw do
	root "courses#index"

	use_doorkeeper do
		skip_controllers :authorizations, :applications, :authorized_applications
	end

	devise_for :admin_users, ActiveAdmin::Devise.config
	ActiveAdmin.routes(self)

	devise_for :accounts, controllers: {
		registrations: "accounts/registrations",
		passwords: "accounts/passwords"
	}

	resources :courses do
		post "/search", to: "courses#search", as: :search, on: :collection
		resources :sections, shallow: true, except: :index do
			resources :daily_reports, shallow: false, only: :update
			resources :daily_reports, only: [:create, :edit, :destroy] do
				member do
					get "feedback", to: "daily_reports#edit_feedback"
					post "feedback", to: "daily_reports#cancel_feedback"
					patch "feedback", to: "daily_reports#update_feedback"
				end
			end
			resources :references, shallow: false, only: :update
			resources :references, only: [:create, :edit, :destroy]
		end
	end

	scope 'course_reports/:course_report_id/' do
		resources :reviews, only: [:new, :create]
	end

	resources :reviews, only: [:edit, :update, :destroy]
	resources :batches, except: [:index, :show]
	resources :daily_reports, only: :index
	resources :accounts, only: :show

	namespace :api, defaults: { format: :json } do
		resources :courses, except: [:new, :edit] do
			post '/search', to: 'courses#search', on: :collection
			resources :sections, shallow: true, except: [:index, :new, :edit] do
				resources :daily_reports, only: [:create, :update, :destroy] do
					patch "feedback", to: 'daily_reports#update_feedback', on: :member
				end
				resources :references, only: [:create, :update, :destroy]
			end
		end

		scope 'course_reports/:course_report_id/' do
			resources :reviews, only: :create
		end
		resources :reviews, only: [:update, :destroy]
		resources :batches, only: [:create, :update, :destroy]
		resources :daily_reports, only: :index
		resources :accounts, only: :show
	end
end
