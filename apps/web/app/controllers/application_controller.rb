class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def current_token
    cookies.signed[:auth_token]
  end

  def authenticated?
    current_token.present? &&
      current_token.expires_at > Time.current
  end
end
