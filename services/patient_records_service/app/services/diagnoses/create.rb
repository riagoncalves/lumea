module Diagnoses
  class Create < ApplicationService
    attr_accessor :documents

    attribute :patient_id, :integer
    attribute :appointment_id, :integer
    attribute :doctor_id, :integer
    attribute :diagnosis_code, :string
    attribute :diagnosed_at, :datetime
    attribute :description, :string, default: nil

    validates :patient_id, :doctor_id, :diagnosis_code, :diagnosed_at, presence: true

    def call
      return false unless valid?
      return false unless save_diagnose

      save_documents
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.message)
      false
    rescue StandardError => e
      errors.add(:base, "An error occurred: #{e.message}")
      false
    end

    def diagnose
      @diagnose
    end

    private

    def save_diagnose
      @diagnose ||= Diagnose.create(
        patient_id: patient_id,
        appointment_id: appointment_id,
        doctor_id: doctor_id,
        diagnosis_code: diagnosis_code,
        diagnosed_at: diagnosed_at,
        description: description
      )
    end

    def save_documents
      return unless documents.present?
      return unless documents.is_a?(Array)

      documents.each do |doc|
        @diagnose.documents.create!(
          file_base64: doc
        )
      end

      true
    end
  end
end
