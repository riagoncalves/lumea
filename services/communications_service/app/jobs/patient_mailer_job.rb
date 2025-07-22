
class PatientMailerJob
  include Sidekiq::Job
  sidekiq_options queue: 'patient_mailer', retry: 5, backtrace: true

  def perform(email:, template:)
    PatientMailer.send(template, email).deliver_now
  rescue StandardError => e
    Rails.logger.error "Failed to send email to #{email}: #{e.message}"
    raise e
  end
end

