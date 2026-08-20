class ApplicationController < ActionController::API
  before_action :app_authentication!

  private

  def app_authentication!
    return if valid_app_secret_key?(request.headers['Authorization'])

    render status: :unauthorized, json: { error: 'Unauthorized' }
  rescue ::AuthenticateTokenError => e
    render status: :unauthorized, json: { error: e.message }
  end

  def valid_app_secret_key?(provided_key)
    return false if provided_key.blank? || app_secret_key.blank?

    ActiveSupport::SecurityUtils.secure_compare(provided_key, app_secret_key)
  end

  def app_secret_key
    ENV.fetch('APP_SECRET_KEY', nil)
  end
end
