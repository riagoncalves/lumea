module Api
  module UsersService
    class Base < ApplicationService
      SERVICE_URL = ENV['USERS_SERVICE_URL']

      def initialize(
        register_service: Api::UsersService::Auth::Register.new
      )
        @register_service = register_service
      end

      protected

      attr_reader :register_service
    end
  end
end
