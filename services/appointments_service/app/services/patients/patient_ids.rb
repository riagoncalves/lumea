module Patients
  class PatientIds < ApplicationService
    attribute :doctor_id, :integer

    attr_reader :patient_ids

    def call
      @patient_ids = Appointment.where(doctor_id: doctor_id).pluck(:patient_id).uniq
    end
  end
end
