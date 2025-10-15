module Public
  module Doctors
    class RegistrationsController < Public::BaseController
      def new
        @form = Api::UsersService::Doctors::Auth::Register.new
      end
    
      def create
        if service.call
          redirect_to doctor_login_path, notice: 'Registration successful.'
        else
          redirect_to doctor_register_path, alert: service.errors.full_messages.join('<br>')
        end
      end
  
      private
  
      def registration_params
        Auth::RegisterParams.new.parse(params)
      end
  
      def service
        @service ||= Api::UsersService::Doctors::Auth::Register.new(registration_params)
      end
    end
  end
end
