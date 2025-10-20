module Public
  module Doctors
    class SessionsController < Public::BaseController
      def new
        @form = Api::UsersService::Doctors::Auth::Login.new
      end
    
      def create
        if service.call
          cookies.signed[:auth_token] = { value: service.auth_token, **cookie_options }
          cookies.signed[:user_type]  = { value: service.user_type,  **cookie_options }
          redirect_to doctor_home_path, notice: 'Login successful.'
        else
          redirect_to doctor_login_path, alert: service.errors.full_messages.join('<br>')
        end
      end
  
      def destroy
        cookies.delete(:auth_token)
        cookies.delete(:user_type)
        redirect_to doctor_login_path
      end
  
      private
  
      def login_params
        Auth::LoginParams.new.parse(params)
      end
  
      def service
        @service ||= Api::UsersService::Doctors::Auth::Login.new(login_params)
      end

      def cookie_options
        { httponly: true, secure: Rails.env.production?, expires: 7.days.from_now }
      end
    end
  end
end
