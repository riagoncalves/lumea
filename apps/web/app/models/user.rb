class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :full_name, :string
  attribute :email, :string
  attribute :gender, :string
  attribute :date_of_birth, :date
  attribute :contact_number, :string
  attribute :address, :string
end
