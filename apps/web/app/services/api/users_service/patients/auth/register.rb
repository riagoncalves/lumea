module Api
  module UsersService
    module Patients
      module Auth
        class Register < Api::UsersService::Base
          attribute :email, :string
          attribute :password, :string
          attribute :password_confirmation, :string

          def call
            url = "#{SERVICE_URL}/patients/auth/register"

            result = register_service.call(
              url:,
              email:,
              password:,
              password_confirmation:
            )

            return true if result

            register_service.errors.full_messages.each do |error|
              errors.add(:base, error)
            end

            false
          end
        end
      end
    end
  end
end
