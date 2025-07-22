
class MarkMissedAppointmentsJob
  include Sidekiq::Job

  def perform
    missed_appointments.update_all(status: 'missed')
  end

  private

  def missed_appointments
    @missed_appointments ||= Appointment.where(status: 'pending')
                                         .where('end_time < ?', Time.current)
  end
end
