Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :sessions, only: [:new, :index] do
    delete :sign_out, action: :destroy, on: :collection
  end

  get '/auth/:provider/callback', as: :auth_google_callback, to: 'sessions#create'

  resources :years, only: [:index, :show] do
    get :current, on: :collection
  end

  resources :badges, only: [:index, :create, :destroy]

  resources :entries, only: %i[update] do
    get 'day_popup_form/:date', to: 'entries#day_popup_form', as: :day_popup_form, on: :collection
    get :search, on: :collection
  end

  resources :users, only: [] do
    get :profile, on: :collection

    resources :be_real_connections, only: [:new, :create, :update] do
      member do
        get :profile
        get :friends
        get :memories
        get :otp
        patch :submit_otp
      end
    end
  end

  root to: 'years#current'
end
