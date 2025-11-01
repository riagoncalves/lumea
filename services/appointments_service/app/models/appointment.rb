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

  def can_start_video_call?
    status.eql?("pending") && (start_time - 5.minutes) <= Time.current && end_time >= Time.current
  end
end
