class SessionNoteSerializer < ApplicationSerializer
  attributes :patient_id, :appointment_id, :doctor_id, :content, :created_at, :updated_at
end
