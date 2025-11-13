module Api
  module UsersService
    class Base < ApplicationService
      SERVICE_URL = ENV['USERS_SERVICE_URL']

      protected

      def register_service
        @register_service ||= Api::UsersService::Auth::Register.new
      end

      def login_service
        @login_service ||= Api::UsersService::Auth::Login.new
      end
    end
  end
end
