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

    decoded_token = decode_auth_token(token)
    raise ::AuthenticateTokenError, 'Unauthorized' if decoded_token.blank?

    @current_user = User.find_by(id: decoded_token['user_id'])

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

  def decode_auth_token(token)
    decoded_token = JWT.decode(
      token,
      ENV.fetch('JWT_SECRET_KEY', nil),
      true
    )

    decoded_token[0]
  rescue JWT::ExpiredSignature
    nil
  rescue JWT::DecodeError
    nil
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
