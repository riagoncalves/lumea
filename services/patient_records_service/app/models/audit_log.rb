class AuditLog
  def self.create!(
    user_id:,
    action:,
    changes:,
    entity_type:,
    entity_id:,
    old_values:,
    new_values:
  )
    log_service = ExternalServices::LogService.new(
      user_id: user_id,
      action: action,
      entity_type: entity_type,
      entity_id: entity_id,
      old_values: old_values,
      new_values: new_values
    )
    log_service.create_audit_log!
  rescue StandardError => e
    Rails.logger.error("Failed to create audit log: #{e.message}")
  end
end
