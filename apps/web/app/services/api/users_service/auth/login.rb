module Api
  module UsersService
    module Auth
      class Login < ApplicationService
        INTERNAL_API_SECRET = ENV["APP_SECRET_KEY"]

        attr_reader :auth_token, :user_type

        def call(
          url:,
          email:,
          password:
        )
          response = Faraday.post(url) do |req|
            req.headers['Authorization'] = INTERNAL_API_SECRET
            req.body = {
              session: {
                email:,
                password:
              }
            }
          end

          handle_response(response)
        end

        private

        def handle_response(response)
          return handle_success(response) if response.status.eql?(200)
          
          response.body["errors"].each do |error|
            errors.add(:base, error)
          end

          false
        end

        def handle_success(response)
          @auth_token = response.body["auth_token"]
          @user_type  = response.body["type"]
        end
      end
    end
  end
end
