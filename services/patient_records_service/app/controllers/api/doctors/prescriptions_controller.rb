module Api
  module Doctors
    class PrescriptionsController < BaseController
      before_action :set_patient

      def index
        render(status: :ok,
               json: prescriptions,
               each_serializer: ::PrescriptionSerializer,
               root: :prescriptions,
               adapter: :json)
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end

      def show
        if prescription
          render(status: :ok,
                 json: prescription,
                 serializer: ::PrescriptionSerializer,
                 root: :prescription,
                 adapter: :json)
        else
          render(status: :not_found, json: { errors: ['Prescription not found'] })
        end
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end

      def create
        if prescription_create_service.call
          render(status: :created,
                 json: prescription_create_service.prescription,
                 serializer: ::PrescriptionSerializer,
                 root: :prescription,
                 adapter: :json)
        else
          render(status: :unprocessable_entity, json: { errors: prescription_create_service.errors.full_messages })
        end
      end

      def update
        if prescription.nil?
          render(status: :not_found, json: { errors: ['Prescription not found'] })
        elsif prescription_update_service.call
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

      def prescription_create_service
        @prescription_create_service ||= Prescriptions::Create.new(prescription_create_params)
      end

      def prescription_update_service
        @prescription_update_service ||= Prescriptions::Update.new(prescription_update_params)
      end

      def prescription_create_params
        prescription_params.merge(
          patient_id: @patient.id,
          doctor_id: current_user.id
        )
      end

      def prescriptions
        @prescriptions ||= Prescription.where(patient_id: @patient.id)
      end

      def prescription
        @prescription ||= Prescription.find_by(id: params[:prescription_id], patient_id: @patient.id)
      end

      def prescription_params
        params.require(:prescription).permit(:appointment_id, :medication_name, :dosage, :frequency, :start_date, :end_date, :notes, documents: [])
      end

      def prescription_update_params
        params.require(:prescription).permit(:medication_name, :dosage, :frequency, :start_date, :end_date, :notes).merge(
          prescription: prescription
        )
      end
    end
  end
end
