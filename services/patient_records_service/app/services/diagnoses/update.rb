module Diagnoses
  class Update < ApplicationService
    attr_accessor :diagnose, :documents

    attribute :diagnosis_code, :string
    attribute :diagnosed_at, :datetime
    attribute :description, :string, default: nil

    validates :diagnosis_code, :diagnosed_at, presence: true

    def call
      return false unless valid?
      return false unless update_diagnose

      save_documents
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.message)
      false
    rescue StandardError => e
      errors.add(:base, "An error occurred: #{e.message}")
      false
    end

    def diagnose
      @diagnose.reload
    end

    private

    def update_diagnose
      @diagnose ||= diagnose.update(
        diagnosis_code: diagnosis_code,
        diagnosed_at: diagnosed_at,
        description: description,
        whodunnit: diagnose.doctor_id,
        old_values: diagnose.attributes
      )
    end

    def save_documents
      return unless documents.present?
      return unless documents.is_a?(Array)

      documents.each do |doc|
        @diagnose.documents.create!(
          file_base64: doc,
          whodunnit: diagnose.doctor_id,
          old_values: {}
        )
      end

      true
    end
  end
end
