module Api
  module Doctors
    class DiagnosesController < BaseController
      before_action :set_patient

      def index
        render(status: :ok,
               json: diagnoses,
               each_serializer: ::DiagnoseSerializer,
               root: :diagnoses,
               adapter: :json)
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end

      def show
        if diagnose
          render(status: :ok,
                 json: diagnose,
                 serializer: ::DiagnoseSerializer,
                 root: :diagnose,
                 adapter: :json)
        else
          render(status: :not_found, json: { errors: ['Diagnose not found'] })
        end
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end

      def create
        
      end

      def update
      end

      private

      def diagnoses
        @diagnoses ||= Diagnose.where(patient_id: @patient.id)
      end

      def diagnose
        @diagnose ||= Diagnose.find_by(id: params[:diagnose_id], patient_id: @patient.id)
      end

      def diagnose_params
        params.require(:diagnose).permit(:appointment_id, :doctor_id, :diagnosis_code, :diagnosed_at, documents: [])
      end
    end
  end
end
