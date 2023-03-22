Rails.application.routes.draw do

	root "courses#index"

	devise_for :admin_users, ActiveAdmin::Devise.config
	ActiveAdmin.routes(self)

	devise_for :accounts, controllers: {
		registrations: "accounts/registrations"
	}

	resources :courses do
		resources :sections, shallow: true, except: :index do
			resources :daily_reports, shallow: false, only: :update
			resources :daily_reports, only: [:create, :edit, :destroy] do
				member do
					get "feedback", to: "daily_reports#feedback"
				end
			end
			resources :references, shallow: false, only: :update
			resources :references, only: [:create, :edit, :destroy]
		end
	end

	resources :course_reports, only: [] do
		resources :reviews, except: [:index, :show], shallow: true
	end

	resources :batches, except: [:index, :show]

	get "reports", to: "daily_reports#index", as: :reports
	get "accounts/:id", to: "accounts#show", as: :account
end
