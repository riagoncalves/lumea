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
        if diagnose_create_service.call
          render(status: :created,
                 json: diagnose_create_service.diagnose,
                 serializer: ::DiagnoseSerializer,
                 root: :diagnose,
                 adapter: :json)
        else
          render(status: :unprocessable_entity, json: { errors: diagnose_create_service.errors.full_messages })
        end
      end

      def update
        if diagnose.nil?
          render(status: :not_found, json: { errors: ['Diagnose not found'] })
        elsif diagnose_update_service.call
          render(status: :ok,
                 json: diagnose_update_service.diagnose,
                 serializer: ::DiagnoseSerializer,
                 root: :diagnose,
                 adapter: :json)
        else
          render(status: :unprocessable_entity, json: { errors: diagnose_update_service.errors.full_messages })
        end
      end

      private

      def diagnose_create_service
        @diagnose_create_service ||= Diagnoses::Create.new(diagnose_create_params)
      end

      def diagnose_update_service
        @diagnose_update_service ||= Diagnoses::Update.new(diagnose_update_params)
      end

      def diagnose_create_params
        diagnose_params.merge(
          patient_id: @patient.id,
          doctor_id: current_user.id
        )
      end

      def diagnoses
        @diagnoses ||= Diagnose.where(patient_id: @patient.id)
      end

      def diagnose
        return @diagnose if defined?(@diagnose)

        @diagnose = Diagnose.find_by(id: params[:diagnose_id], patient_id: @patient.id)
        set_log_attributes(record: @diagnose)
        @diagnose
      end

      def diagnose_params
        params.require(:diagnose).permit(:appointment_id, :diagnosis_code, :diagnosed_at, documents: [])
      end

      def diagnose_update_params
        params.require(:diagnose).permit(:diagnosis_code, :diagnosed_at, :description, documents: []).merge(
          diagnose: diagnose
        )
      end
    end
  end
end
