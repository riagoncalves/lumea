module Api
  module UsersService
    module Patients
      module Auth
        class Register < Api::UsersService::Base
          attribute :email, :string
          attribute :password, :string
          attribute :password_confirmation, :string

          def call
            response = Faraday.post("#{SERVICE_URL}/patients/auth/register") do |req|
              req.headers['Authorization'] = INTERNAL_API_SECRET
              req.body = {
                email: email,
                password: password,
                password_confirmation: password_confirmation
              }
            end

            handle_response(response)
          end

          private

          def handle_response(response)
            return true if response.status.eql?(201)
            
            errors.add(:base, "Unexpected error: #{response.status} - #{response.body}")
            false
          end
        end
      end
    end
  end
end
