class AuditLogJob < ApplicationJob
  queue_as :audit_logging
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform(user_id:, action:, entity_type:, entity_id:, old_values:, new_values:)
    ExternalServices::LogService.new(
      user_id: user_id,
      action: action,
      entity_type: entity_type,
      entity_id: entity_id,
      old_values: old_values,
      new_values: new_values
    ).create_audit_log!
  rescue StandardError => e
    Rails.logger.error("Failed to create audit log for #{entity_type}##{entity_id}: #{e.message}")
    raise e
  end
end
