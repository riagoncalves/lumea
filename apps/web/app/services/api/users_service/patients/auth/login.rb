module Api
  module UsersService
    module Patients
      module Auth
        class Login < Api::UsersService::Base
          attribute :email, :string
          attribute :password, :string

          def call
            url = "#{SERVICE_URL}/patients/auth/login"

            login_service.call(
              url:,
              email:,
              password:
            )
          end
        end
      end
    end
  end
end
