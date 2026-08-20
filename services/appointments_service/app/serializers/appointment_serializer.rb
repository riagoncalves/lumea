class AppointmentSerializer < ApplicationSerializer
  attributes :id, :status, :start_time, :end_time, :created_at, :updated_at, :doctor_id, :patient_id, :doctor, :patient, :can_start_video_call

  def doctor
    prefetched_doctor_details || (doctor_details_service.call ? doctor_details_service.doctor : {})
  end

  def patient
    prefetched_patient_details || (patient_details_service.call ? patient_details_service.patient : {})
  end

  def can_start_video_call
    object.can_start_video_call?
  end

  private

  # Populated only on #index, where AppointmentsController prefetches every
  # unique doctor/patient once, concurrently, instead of once per row.
  def prefetched_doctor_details
    instance_options[:doctor_details_by_id]&.[](object.doctor_id)
  end

  def prefetched_patient_details
    instance_options[:patient_details_by_id]&.[](object.patient_id)
  end

  def doctor_details_service
    @doctor_details_service ||= ExternalServices::DoctorDetailsService::Show.new(doctor_id: object.doctor_id)
  end

  def patient_details_service
    @patient_details_service ||= ExternalServices::PatientRecordsService::PatientDetails::Show.new(patient_id: object.patient_id)
  end
end
