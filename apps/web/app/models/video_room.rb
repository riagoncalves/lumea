class VideoRoom
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :name, :string
  attribute :status, :string
  attribute :doctor_id, :integer
  attribute :patient_id, :integer
  attribute :appointment_id, :integer
  attribute :access_token, :string
  attribute :room_sid, :string
end
