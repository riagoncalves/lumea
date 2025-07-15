class SessionNote < ApplicationRecord
  include Loggable

  has_many :documents, as: :documentable, dependent: :destroy

  validates :patient_id, :doctor_id, :content, presence: true
end
