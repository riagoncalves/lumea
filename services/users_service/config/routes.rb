Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  scope :api, as: :api, module: :api do
    scope :users do
      get "me", to: "users#show", as: :me
      put "me", to: "users#update", as: :update_me
      put "me/password", to: "users#update_password", as: :update_password
    end

    scope :doctors, as: :doctor, module: :doctors do
      get 'patients/:id', to: 'patients#show', as: :patient
      put 'patients/:id', to: 'patients#update', as: :update_patient

      scope :auth, module: :auth do
        post "login", to: "sessions#create", as: :login
        post "register", to: "registrations#create", as: :register
      end
    end

    scope :patients, as: :patient, module: :patients do
      scope :auth, module: :auth do
        post "login", to: "sessions#create", as: :login
        post "register", to: "registrations#create", as: :register
      end
    end

    scope :external_services, module: :external_services do
      get 'users/:id', to: 'users#show', as: :user
    end
  end
end
