class UserSerializer < ApplicationSerializer
  attributes :id, :email, :type, :created_at, :updated_at
end
