module Api
  module UsersService
    module Doctors
      module Auth
        class Login < Api::UsersService::Base
          attribute :email, :string
          attribute :password, :string

          def call
            url = "#{SERVICE_URL}/doctors/auth/login"

            result = login_service.call(
              url:,
              email:,
              password:
            )

            return true if result

            login_service.errors.full_messages.each do |error|
              errors.add(:base, error)
            end

            false
          end

          def auth_token
            login_service.auth_token
          end

          def user_type
            login_service.user_type
          end
        end
      end
    end
  end
end
