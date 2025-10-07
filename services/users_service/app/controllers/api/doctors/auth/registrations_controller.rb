module Api
  module Doctors
    module Auth
      class RegistrationsController < ApplicationController
        skip_before_action :authenticate_user!
        before_action :app_authentication!
  
        def create
          if service.call
            render(status: :created)
          else
            render(status: :unprocessable_entity, json: service, serializer: ::ErrorSerializer)
          end
        rescue StandardError => e
          render json: { errors: [e.message] }, status: :internal_server_error
        end
  
        private
  
        def service
          @service ||= ::Auth::Register.new(registration_params)
        end
  
        def registration_params
            params.require(:registration).permit(:email, :password, :password_confirmation).merge(
              type: 'doctor'
            )
        end
      end
    end
  end
end
