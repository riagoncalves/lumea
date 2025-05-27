module Api
  module ExternalServices
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :app_authentication!

      def show
        render(status: :ok,
                   json: user,
                   serializer: ::UserSerializer,
                   root: :user,
                   adapter: :json)
      rescue  ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['User not found'] })
      end

      private

      def user
        @user ||= User.find(params[:id])
      end

    end
  end
end
