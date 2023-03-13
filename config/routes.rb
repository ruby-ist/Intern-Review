Rails.application.routes.draw do
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

	root "courses#index"
	resources :courses do
		resources :sections, shallow: true, except: :index do
			resources :daily_reports, shallow: false, only: :update
			resources :daily_reports, only: [:create, :edit, :destroy]

			resources :references, shallow: false, only: :update
			resources :references, only: [:create, :edit, :destroy]
		end
	end
end
