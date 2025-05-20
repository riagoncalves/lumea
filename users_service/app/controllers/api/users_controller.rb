module Api
  class UsersController < ApplicationController
    def show
      render(status: :ok,
                 json: current_user,
                 serializer: ::UserSerializer,
                 root: :user,
                 adapter: :json)
    end

    def update
      if current_user.update(user_params)
        render(status: :ok,
               json: current_user,
               serializer: ::UserSerializer,
               root: :user,
               adapter: :json)
      else
        render(status: :unprocessable_entity, json: current_user, serializer: ::ErrorSerializer)
      end
    end

    def update_password
      if current_user.valid_password?(update_password_params[:old_password])
        if current_user.update(update_password_params)
          render(status: :ok,
                 json: current_user,
                 serializer: ::UserSerializer,
                 root: :user,
                 adapter: :json)
        else
          render(status: :unprocessable_entity, json: current_user, serializer: ::ErrorSerializer)
        end
      else
        render(status: :unauthorized, json: { errors: ['Invalid password'] })
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end

    def update_password_params
      params.require(:user).permit(:old_password, :password, :password_confirmation)
    end
  end
end
