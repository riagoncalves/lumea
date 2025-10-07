module Api
  module UsersService
    module Doctors
      module Auth
        class Register < Api::UsersService::Base
          attribute :email, :string
          attribute :password, :string
          attribute :password_confirmation, :string

          def call
            register_service.call(
              url:,
              email:,
              password:,
              password_confirmation:
            )
          end
        end
      end
    end
  end
end
