class Appointment < ApplicationRecord
  include Loggable

  scope :upcoming, -> { where('start_time >= ?', Time.current).order(:start_time) }
  scope :past, -> { where('start_time < ?', Time.current).order(start_time: :desc) }

  enum :status, {
    pending: 'pending',
    completed: 'completed',
    cancelled: 'cancelled',
    missed: 'missed'
  }

  def mark_as_completed
    update(status: :completed)
  end

  def destroy
    update(status: :cancelled)
  end
end
