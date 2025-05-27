module Appointments
  class Update < ApplicationService
    include ::AppointmentFields
    attr_accessor :appointment

    def call
      return false unless valid?

      appointment.update(
        doctor_id: doctor_id,
        start_time: start_time,
        end_time: end_time
      )
    end

    private

    def patient_id
      appointment.patient_id
    end
  end
end
