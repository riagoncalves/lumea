module AuthHelper
  def current_token
    cookies.signed[:auth_token]
  end

  def authenticated?
    current_token.present?
  end

  def patient?
    cookies.signed[:user_type].eql?('patient')
  end

  def doctor?
    cookies.signed[:user_type].eql?('doctor')
  end
end
