Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  scope :api, as: :api, module: :api do
    resources :video_calls, only: [:create, :show], controller: 'video_calls'
    post 'twilio/webhook', to: 'twilio#webhook', as: :twilio_webhook
  end
end
