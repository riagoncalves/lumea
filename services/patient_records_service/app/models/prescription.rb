class Prescription < ApplicationRecord
  has_many :documents, as: :documentable, dependent: :destroy
end
