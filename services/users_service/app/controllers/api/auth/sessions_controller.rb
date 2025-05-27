module Api
  module Auth
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :app_authentication!

      def create
        if user&.valid_password?(session_params[:password])
          render json: { auth_token: user.auth_token }, status: :ok
        else
          render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
      rescue StandardError => e
        render json: { errors: [e.message] }, status: :internal_server_error
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end

      def user
        @user ||= User.find_for_database_authentication(email: session_params[:email])
      end
    end
  end
end
