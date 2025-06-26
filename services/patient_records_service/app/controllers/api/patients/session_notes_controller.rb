module Api
  module Patients
    class SessionNotesController < ApplicationController
      def index
        render(status: :ok,
               json: session_notes,
               each_serializer: ::SessionNoteSerializer,
               root: :session_notes,
               adapter: :json)
      end

      private

      def session_notes
        @session_notes ||= SessionNote.where(patient_id: current_user.id)
      end
    end
  end
end
