class PrescriptionSerializer < ApplicationSerializer
  attributes :patient_id, :appointment_id, :doctor_id, :medication_name, :dosage,
             :frequency, :start_date, :end_date, :notes, :created_at, :updated_at

  def documents
    object.documents.map do |document|
      document.file.url
    end
  rescue StandardError => e
    Rails.logger.error("Error serializing documents: #{e.message}")
    []
  end
end
