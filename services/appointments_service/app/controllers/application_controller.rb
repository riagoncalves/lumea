class ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :set_log_attributes

  private

  def require_doctor!
    return if current_user&.doctor?

    render status: :unauthorized, json: { error: 'Unauthorized' }
  end

  def authenticate_user!
    token = request.headers['Authorization']
    raise ::AuthenticateTokenError, 'Unauthorized' if token.blank?

    ::ExternalServices::UsersService.get_current_user(token).tap do |user|
      raise ::AuthenticateTokenError, 'Unauthorized' unless user.present?
      @current_user = user
    rescue Unauthorized
      raise ::AuthenticateTokenError, 'Unauthorized'
    rescue StandardError
      raise ::AuthenticateTokenError, 'An error occurred while authenticating the user'
    end

    return if @current_user.present?
    render status: :unauthorized, json: { error: 'Unauthorized' }
  rescue ::AuthenticateTokenError => e
    render status: :unauthorized, json: { error: e.message }
  end

  def app_authentication!
    return if app_secret_key.present? && request.headers['Authorization'].eql?(app_secret_key)

    render status: :unauthorized, json: { error: 'Unauthorized' }
  rescue ::AuthenticateTokenError => e
    render status: :unauthorized, json: { error: e.message }
  end

  def app_secret_key
    ENV.fetch('APP_SECRET_KEY', nil)
  end

  def current_user
    @current_user
  end

  def set_log_attributes(record: nil)
    target_record = record || current_user
    return unless target_record.present?
    return unless target_record.respond_to?(:whodunnit)

    target_record.whodunnit = current_user&.id
    target_record.old_values = target_record.attributes
  end
end
