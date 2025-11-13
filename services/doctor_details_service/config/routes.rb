Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  scope :api, as: :api, module: :api do
    scope :public, as: :public, module: :public do
      get 'doctor_details', to: 'doctor_details#index', as: :doctor_details_index
      get 'doctor_details/:doctor_id', to: 'doctor_details#show', as: :doctor_detail
    end

    scope :doctors, as: :doctor, module: :doctors do
      get 'doctor_details', to: 'doctor_details#show', as: :doctor_details
      put 'doctor_details/update', to: 'doctor_details#update', as: :update_doctor_details
    end
  end
end
