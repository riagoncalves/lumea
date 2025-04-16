class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  
  def auth_token
    JWT.encode(
      { user_id: id, exp: 1.week.from_now.to_i },
      Rails.application.credentials.devise_jwt_secret_key
    )
  end
end
