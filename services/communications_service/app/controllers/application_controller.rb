class ApplicationController < ActionController::API
  before_action :app_authentication!

  private

  def app_authentication!
    return if app_secret_key.present? && request.headers['Authorization'].eql?(app_secret_key)

    render status: :unauthorized, json: { error: 'Unauthorized' }
  rescue ::AuthenticateTokenError => e
    render status: :unauthorized, json: { error: e.message }
  end

  def app_secret_key
    ENV.fetch('APP_SECRET_KEY', nil)
  end
end
