class AppointmentSerializer < ApplicationSerializer
  attributes :id, :status, :start_time, :end_time, :created_at, :updated_at
end
