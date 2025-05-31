Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  scope :api, as: :api, module: :api do
    get 'patient_details', to: 'patient_details#show', as: :patient_details
    put 'patient_details/update', to: 'patient_details#update', as: :update_patient_details

    scope :doctors, as: :doctor, module: :doctors do
      get 'patient_details/:id', to: 'patient_details#show', as: :patient_details
      put 'patient_details/:id/update', to: 'patient_details#update', as: :update_patient_details
    end
  end
end
