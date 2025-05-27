class ApplicationController < ActionController::API
  before_action :authenticate_user!

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

    user_id = decoded_token['user_id']

    ::ExternalServices::UsersService.get_user(user_id).tap do |user|
      raise ::AuthenticateTokenError, 'Unauthorized' unless user.present?
      @current_user = user
    rescue UserNotFound
      raise ::AuthenticateTokenError, 'Unauthorized'
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
end
