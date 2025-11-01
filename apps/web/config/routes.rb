Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  
  scope module: :public do
    get "register", to: "registrations#new", as: :register
    post "register", to: "registrations#create", as: :create_register

    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create", as: :create_login
    delete "logout", to: "sessions#destroy", as: :logout

    scope :doctors, as: :doctor, module: :doctors do
      get "register", to: "registrations#new", as: :register
      post "register", to: "registrations#create", as: :create_register

      get "login", to: "sessions#new", as: :login
      post "login", to: "sessions#create", as: :create_login
      delete "logout", to: "sessions#destroy", as: :logout
    end
  end

  scope :patients, as: :patient, module: :patients do
    root to: "home#index", as: :home

    get "appointments", to: "appointments#index", as: :appointments
    get "appointments/new", to: "appointments#new", as: :new_appointment
    post "appointments", to: "appointments#create", as: :create_appointment
    get "appointments/:id", to: "appointments#show", as: :appointment
    get "appointments/:id/edit", to: "appointments#edit", as: :edit_appointment
    put "appointments/:id", to: "appointments#update", as: :update_appointment
    put "appointments/:id/complete", to: "appointments#complete", as: :complete_appointment
    delete "appointments/:id", to: "appointments#destroy", as: :cancel_appointment

    get "appointments/:id/room", to: "appointment_rooms#show", as: :appointment_room
  end

  scope :doctors, as: :doctor, module: :doctors do
    root to: "home#index", as: :home

    get "appointments", to: "appointments#index", as: :appointments
    get "appointments/:id", to: "appointments#show", as: :appointment
    put "appointments/:id/complete", to: "appointments#complete", as: :complete_appointment
    delete "appointments/:id", to: "appointments#destroy", as: :cancel_appointment
  end
end
