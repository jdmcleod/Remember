Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :sessions, only: [:new, :index, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create'

  root to: 'years#current'

  resources :years, only: [:index, :show] do
    get :current, on: :collection
  end

  resources :entries, only: %i[update] do
    get 'day_popup_form/:date', to: 'entries#day_popup_form', as: :day_popup_form, on: :collection
  end
end
