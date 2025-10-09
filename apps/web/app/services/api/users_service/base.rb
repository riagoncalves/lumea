module Api
  module UsersService
    class Base < ApplicationService
      SERVICE_URL = ENV['USERS_SERVICE_URL']

      protected

      def register_service
        @register_service ||= Api::UsersService::Auth::Register.new
      end
    end
  end
end
