Rails.application.routes.draw do
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

	root "courses#index"
	resources :courses do
		resources :sections, shallow: true, except: :index do
			resources :daily_reports, shallow: false, except: %w{ index show new }
		end
	end
end
