module Api
  module Patients
    class PrescriptionsController < ApplicationController
      def index
        render(status: :ok,
               json: prescriptions,
               each_serializer: ::PrescriptionSerializer,
               root: :prescriptions,
               adapter: :json)
      end

      private

      def prescriptions
        @prescriptions ||= Prescription.where(patient_id: current_user.id)
      end
    end
  end
end
