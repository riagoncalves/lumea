class PatientMailer < ApplicationMailer
  def welcome_email(email)
    mail(to: email, subject: 'Welcome to My App')
  end
end
