class Appointment < ApplicationRecord
  validates :start_time, presence: true
  validates :status, presence: true
  validates :doctor_id, presence: true
  validates :patient_id, presence: true

  enum status: {
    pending: 'pending',
    completed: 'completed',
    cancelled: 'cancelled',
    missed: 'missed'
  }

  scope :upcoming, -> { where('start_time >= ?', Time.current).order(:start_time) }
  scope :past, -> { where('start_time < ?', Time.current).order(start_time: :desc) }
end
