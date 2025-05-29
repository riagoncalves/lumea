class SessionNote < ApplicationRecord
  has_many :documents, as: :documentable, dependent: :destroy
end
