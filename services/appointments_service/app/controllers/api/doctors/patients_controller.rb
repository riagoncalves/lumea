module Api
  module Doctors
    class PatientsController < ApplicationController
      def index
        if current_user.doctor?
          patient_ids_service.call
          render(status: :ok,
                  json: patient_ids_service,
                  serializer: ::PatientIdsSerializer,
                  root: :patients,
                  adapter: :json)
        else
          render(status: :unauthorized, json: { errors: ['Access denied'] })
        end
      end
  
      private
  
      def patient_ids_service
        @patient_ids_service ||= Patients::PatientIds.new(doctor_id: current_user.id)
      end
    end
  end
end
