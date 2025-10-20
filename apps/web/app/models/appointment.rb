class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :status, :string
  attribute :start_time, :datetime
  attribute :end_time, :datetime
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :doctor_id, :integer
  attribute :patient_id, :integer
end
