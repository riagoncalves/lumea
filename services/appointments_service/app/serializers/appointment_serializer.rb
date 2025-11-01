class AppointmentSerializer < ApplicationSerializer
  attributes :id, :status, :start_time, :end_time, :created_at, :updated_at, :doctor_id, :patient_id, :doctor, :can_start_video_call

  def doctor
    if doctor_details_service.call
      doctor_details_service.doctor
    else
      {}
    end
  end

  def can_start_video_call
    object.can_start_video_call?
  end

  private

  def doctor_details_service
    @doctor_details_service ||= ExternalServices::DoctorDetailsService::Show.new(doctor_id: object.doctor_id)
  end
end
