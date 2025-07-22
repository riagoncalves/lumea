module Loggable
  extend ActiveSupport::Concern

  included do
    attr_accessor :whodunnit, :old_values

    after_create :log_create_audit
    after_update :log_update_audit
  end

  private

  def log_create_audit
    create_audit_log('create')
  end

  def log_update_audit
    create_audit_log('update')
  end

  def create_audit_log(action)
    AuditLog.create!(
      user_id: whodunnit,
      action: action,
      changes: previous_changes,
      old_values: old_values,
      new_values: attributes,
      entity_type: self.class.name,
      entity_id: id
    )
  end
end
