class VideoRoomSerializer < ApplicationSerializer
  attributes :id, :name, :status, :doctor_id, :patient_id, :appointment_id, :access_token, :room_sid
end
