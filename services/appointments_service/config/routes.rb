Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  scope :api, as: :api, module: :api do
    scope :appointments do
      get '/', to: "appointments#index", as: :appointments
      post "create", to: "appointments#create", as: :create_appointment
      get ":id", to: "appointments#show", as: :appointment
      put ":id", to: "appointments#update", as: :update_appointment
      put ":id/complete", to: "appointments#complete", as: :complete_appointment
      delete ":id/cancel", to: "appointments#destroy", as: :delete_appointment
    end

    scope :doctors, as: :doctors, module: :doctors do
      get "patients", to: "patients#index", as: :patients
    end
  end
end
