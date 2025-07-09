class AuditLog < ApplicationRecord
  # Validations
  validates :action, presence: true
  validates :entity_type, presence: true
  validates :entity_id, presence: true
end
