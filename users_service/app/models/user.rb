class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  attr_accessor :old_password
  
  def auth_token
    JWT.encode(
      { user_id: id, exp: 1.week.from_now.to_i },
      ENV.fetch('JWT_SECRET_KEY', nil)
    )
  end
end
