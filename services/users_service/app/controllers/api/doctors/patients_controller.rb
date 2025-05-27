module Api
  module Doctors
    class PatientsController < ApplicationController
      before_action :require_doctor!
      before_action :patient, only: [:show, :update]
  
      def show
        render(status: :ok,
                   json: patient,
                   serializer: ::UserSerializer,
                   root: :patient,
                   adapter: :json)
      end
  
      def update
        if patient.update(patient_params)
          render(status: :ok,
                 json: patient,
                 serializer: ::UserSerializer,
                 root: :patient,
                 adapter: :json)
        else
          render(status: :unprocessable_entity, json: patient, serializer: ::ErrorSerializer)
        end
      end
  
      private
  
      def patient
        @patient ||= Patient.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end
  
      def patient_params
        params.require(:patient)
      end
    end
  end
end
