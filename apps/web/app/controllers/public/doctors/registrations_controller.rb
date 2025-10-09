module Public
  module Doctors
    class RegistrationsController < Public::BaseController
      def new
        @form = Api::UsersService::Patients::Auth::Register.new
      end
    
      def create
        if service.call
          
        end
      end

      private

      def registration_params
        Auth::RegisterParams.new.parse(params)
      end

      def service
        @service ||= Api::UsersService::Patients::Auth::Register.new(registration_params)
      end
    end
  end
end
 