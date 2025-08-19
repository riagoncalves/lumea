class VVideoRoomSerializer < ApplicationSerializer
  attributes :id, :name, :status, :doctor_id, :patient_id, :access_token
end
