class Prescription < ApplicationRecord
  include Loggable

  has_many :documents, as: :documentable, dependent: :destroy
end
