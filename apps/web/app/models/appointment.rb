class Appointment
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :doctor

  attribute :id, :integer
  attribute :status, :string
  attribute :start_time, :datetime
  attribute :end_time, :datetime
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :doctor_id, :integer
  attribute :patient_id, :integer

  def can_be_edited?
    status.eql?("pending") && start_time > Time.current
  end
end
