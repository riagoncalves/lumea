module Api
  module Patients
    class DiagnosesController < ApplicationController
      def index
        render(status: :ok,
               json: diagnoses,
               each_serializer: ::DiagnoseSerializer,
               root: :diagnoses,
               adapter: :json)
      end

      private

      def diagnoses
        @diagnoses ||= Diagnose.where(patient_id: current_user.id)
      end
    end
  end
end
