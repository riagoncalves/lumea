module Api
  module Doctors
    class SessionNotesController < BaseController
      before_action :set_patient

      def index
        render(status: :ok,
               json: session_notes,
               each_serializer: ::SessionNoteSerializer,
               root: :session_notes,
               adapter: :json)
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end

      def show
        if session_note
          render(status: :ok,
                 json: session_note,
                 serializer: ::SessionNoteSerializer,
                 root: :session_note,
                 adapter: :json)
        else
          render(status: :not_found, json: { errors: ['Session note not found'] })
        end
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Patient not found'] })
      end

      def create
        session_note = SessionNote.new(session_note_create_params)
        if session_note.save
          render(status: :created,
                 json: session_note,
                 serializer: ::SessionNoteSerializer,
                 root: :session_note,
                 adapter: :json)
        else
          render(status: :unprocessable_entity, json: { errors: session_note.errors.full_messages })
        end
      end

      def update
        if session_note.nil?
          render(status: :not_found, json: { errors: ['Session note not found'] })
        elsif session_note.update(session_note_update_params)
          render(status: :ok,
                 json: session_note,
                 serializer: ::SessionNoteSerializer,
                 root: :session_note,
                 adapter: :json)
        else
          render(status: :unprocessable_entity, json: { errors: session_note.errors.full_messages })
        end
      end

      private

      def prescription_create_service
        @prescription_create_service ||= Prescriptions::Create.new(prescription_create_params)
      end

      def prescription_update_service
        @prescription_update_service ||= Prescriptions::Update.new(prescription_update_params)
      end

      def session_note_create_params
        session_note_params.merge(
          patient_id: @patient.id,
          doctor_id: current_user.id
        )
      end

      def session_notes
        @session_notes ||= SessionNote.where(patient_id: @patient.id)
      end

      def session_note
        @session_note ||= SessionNote.find_by(id: params[:session_note_id], patient_id: @patient.id)
      end

      def session_note_params
        params.require(:session_note).permit(:appointment_id, :doctor_id, :content)
      end

      def session_note_update_params
        params.require(:session_note).permit(:content)
      end
    end
  end
end
