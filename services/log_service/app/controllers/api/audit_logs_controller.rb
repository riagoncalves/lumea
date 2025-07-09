module Api
  class AuditLogsController < ApplicationController
    def create
      @audit_log = AuditLog.new(audit_log_params)

      if @audit_log.save
        header :created
      else
        render json: @audit_log.errors, status: :unprocessable_entity
      end
    end

    private

    def audit_log_params
      params.require(:audit_log).permit(:user_id, :action, :entity_type, :entity_id, :old_values, :new_values)
    end
  end
end
