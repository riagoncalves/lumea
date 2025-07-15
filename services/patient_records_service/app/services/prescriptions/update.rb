module Prescriptions
  class Update < ApplicationService
    attr_accessor :prescription, :documents

    attribute :medication_name, :string
    attribute :dosage, :string
    attribute :frequency, :string
    attribute :start_date, :datetime
    attribute :end_date, :datetime
    attribute :notes, :string, default: nil

    validates :medication_name, :dosage, :frequency, :start_date, :end_date, presence: true

    def call
      return false unless valid?
      return false unless update_prescription

      save_documents
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.message)
      false
    rescue StandardError => e
      errors.add(:base, "An error occurred: #{e.message}")
      false
    end

    def prescription
      @prescription.reload
    end

    private

    def update_prescription
      @prescription ||= prescription.update(
        medication_name: medication_name,
        dosage: dosage,
        frequency: frequency,
        start_date: start_date,
        end_date: end_date,
        notes: notes,
        whodunnit: prescription.doctor_id,
        old_values: prescription.attributes
      )
    end

    def save_documents
      return unless documents.present?
      return unless documents.is_a?(Array)

      documents.each do |doc|
        @prescription.documents.create!(
          file_base64: doc,
          whodunnit: prescription.doctor_id,
          old_values: {}
        )
      end

      true
    end
  end
end
