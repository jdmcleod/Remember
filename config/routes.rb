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
    get :mobile_view, on: :collection
    resources :events
  end

  resources :months, only: [:show] do
    get :entry_form, on: :member
    patch :update_entry, on: :member
  end
  resources :badges, only: [:index, :new, :edit, :create, :update, :destroy]

  resources :entries, only: %i[update] do
    get :search, on: :collection
  end

  resources :days do
    get 'popup_form/:date', to: 'days#popup_form', as: :popup_form, on: :collection
    post 'add_badge/:badge_id', on: :member, to: 'days#add_badge', as: :add_badge
    delete 'remove_badge/:badge_id', on: :member, to: 'days#remove_badge', as: :remove_badge
    patch :add_image_attachment, on: :member
    delete :delete_image_attachment, on: :member
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

  resources :admin, only: [:index]

  root to: 'years#current'

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "pwa#manifest", as: :pwa_manifest
end
