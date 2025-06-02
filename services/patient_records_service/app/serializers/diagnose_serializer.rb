class DiagnoseSerializer < ApplicationSerializer
  attributes :patient_id, :appointment_id, :doctor_id, :diagnosis_code, :diagnosed_at, :documents

  def documents
    object.documents.map do |document|
      document.file.url
    end
  rescue StandardError => e
    Rails.logger.error("Error serializing documents: #{e.message}")
    []
  end
end
