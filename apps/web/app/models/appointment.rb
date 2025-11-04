class Appointment
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :doctor, :patient

  attribute :id, :integer
  attribute :status, :string
  attribute :start_time, :datetime
  attribute :end_time, :datetime
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :doctor_id, :integer
  attribute :patient_id, :integer
  attribute :can_start_video_call, :boolean, default: false

  def can_be_edited?
    status.eql?("pending") && start_time > Time.current
  end

  def can_join_room?
    can_start_video_call
  end
end
