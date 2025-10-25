class AppointmentSerializer < ApplicationSerializer
  attributes :id, :status, :start_time, :end_time, :created_at, :updated_at, :doctor_id, :patient_id, :doctor

  def doctor
    ExternalServices::DoctorDetailsService::Show.call(doctor_id: object.doctor_id).doctor
  end
end
