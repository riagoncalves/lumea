module Prescriptions
  class Create < ApplicationService
    attr_accessor :documents

    attribute :patient_id, :integer
    attribute :appointment_id, :integer
    attribute :doctor_id, :integer
    attribute :medication_name, :string
    attribute :dosage, :string
    attribute :frequency, :string
    attribute :start_date, :datetime
    attribute :end_date, :datetime
    attribute :notes, :string
    attribute :description, :string, default: nil

    validates :patient_id, :doctor_id, :medication_name, :dosage, :frequency, :start_date, :end_date, presence: true

    def call
      return false unless valid?
      return false unless save_prescription

      save_documents
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.message)
      false
    rescue StandardError => e
      errors.add(:base, "An error occurred: #{e.message}")
      false
    end

    def prescription
      @prescription
    end

    private

    def save_prescription
      @prescription ||= Prescription.create(
        patient_id: patient_id,
        appointment_id: appointment_id,
        doctor_id: doctor_id,
        medication_name: medication_name,
        dosage: dosage,
        frequency: frequency,
        start_date: start_date,
        end_date: end_date,
        notes: notes,
        old_values: {},
        whodunnit: doctor_id
      )
    end

    def save_documents
      return unless documents.present?
      return unless documents.is_a?(Array)

      documents.each do |doc|
        @prescription.documents.create!(
          file_base64: doc,
          whodunnit: doctor_id,
          old_values: {}
        )
      end

      true
    end
  end
end
