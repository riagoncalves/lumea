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
        @diagnoses ||= current_user.diagnoses
      end
    end
  end
end
