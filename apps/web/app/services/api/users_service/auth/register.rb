module Api
  module UsersService
    module Auth
      class Register < ApplicationService
        INTERNAL_API_SECRET = ENV["APP_SECRET_KEY"]

        def call(
          url:,
          email:,
          password:,
          password_confirmation:
        )
          response = Faraday.post(url) do |req|
            req.headers['Authorization'] = INTERNAL_API_SECRET
            req.body = {
              email:,
              password:,
              password_confirmation:
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
