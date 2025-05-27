module AppointmentFields
  extend ActiveSupport::Concern

  included do
    attribute :doctor_id, :integer
    attribute :start_time, :datetime
    attribute :end_time, :datetime

    validates :doctor_id, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true

    validate :validate_doctor_exists
    validate :validate_patient_exists
    validate :validate_time_slot_availability
  end

  private

  def validate_doctor_exists
    ::ExternalServices::UsersService.get_user(doctor_id).tap do |doctor|
      unless doctor && doctor.doctor?
        errors.add(:doctor_id, 'not found or is not a valid doctor')
      end
    rescue UserNotFound
      errors.add(:doctor_id, 'not found')
    rescue Unauthorized
    rescue StandardError
      errors.add(:doctor_id, 'An error occurred while validating the doctor')
    end
  end

  def validate_patient_exists
    ::ExternalServices::UsersService.get_user(patient_id).tap do |patient|
      unless patient && patient.patient?
        errors.add(:patient_id, "not found or is not a valid patient #{patient_id}")
      end
    rescue UserNotFound
      errors.add(:patient_id, 'not found')
    rescue Unauthorized
    rescue StandardError
      errors.add(:patient_id, 'An error occurred while validating the patient')
    end
  end

  def validate_time_slot_availability
    return unless colliding_doctor_appointments.present? || colliding_patient_appointments.present?

    if colliding_doctor_appointments.present?
      errors.add(:start_time, 'Doctor is not available during this time slot')
    end

    if colliding_patient_appointments.present?
      errors.add(:start_time, 'Patient has another appointment during this time slot')
    end
  end

  def colliding_doctor_appointments
    @doctor_appointments ||= colliding_query(:doctor_id, doctor_id)
  end

  def colliding_patient_appointments
    @patient_appointments ||= colliding_query(:patient_id, patient_id)
  end

  def colliding_query(user_id_field, user_id)
    Appointment.pending.where(
      "#{user_id_field}": user_id
    ).where(
      'start_time < ? AND end_time > ?',
      end_time, start_time
    )
  end
end
