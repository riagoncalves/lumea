class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :email, :string
  attribute :type, :string
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  def doctor?
    type.eql?("Doctor")
  end

  def patient?
    type.eql?("Patient")
  end
end
