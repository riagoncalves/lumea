Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  scope :api, as: :api, module: :api do
    scope :patients, as: :patient, module: :patients do
      get 'patient_details', to: 'patient_details#show', as: :patient_details
      put 'patient_details/update', to: 'patient_details#update', as: :update_patient_details

      get 'diagnoses', to: 'diagnoses#index', as: :diagnoses

      get 'prescriptions', to: 'prescriptions#index', as: :prescriptions
    end

    scope :doctors, as: :doctor, module: :doctors do
      get 'patient_details/:id', to: 'patient_details#show', as: :patient_details
      put 'patient_details/:id/update', to: 'patient_details#update', as: :update_patient_details

      get 'diagnoses/:id', to: 'diagnoses#index', as: :diagnoses
      get 'diagnoses/:id/:diagnose_id', to: 'diagnoses#show', as: :diagnosis
      post 'diagnoses/:id/create', to: 'diagnoses#create', as: :create_diagnosis
      put 'diagnoses/:id/:diagnose_id/update', to: 'diagnoses#update', as: :update_diagnosis

      get 'prescriptions/:id', to: 'prescriptions#index', as: :prescriptions
      get 'prescriptions/:id/:prescription_id', to: 'prescriptions#show', as: :prescription
      post 'prescriptions/:id/create', to: 'prescriptions#create', as: :create_prescription
      put 'prescriptions/:id/:prescription_id/update', to: 'prescriptions#update', as: :update_prescription
    end
  end
end
