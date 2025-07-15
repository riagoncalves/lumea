module Appointments
  class Create < ApplicationService
    include ::AppointmentFields

    attribute :patient_id, :integer
    validates :patient_id, presence: true

    def call
      return false unless valid?

      appointment.save
    end

    def appointment
      @appointment ||= Appointment.new(
        doctor_id: doctor_id,
        patient_id: patient_id,
        start_time: start_time,
        end_time: end_time,
        whodunnit: patient_id,
        old_values: {}
      )
    end
  end
end
