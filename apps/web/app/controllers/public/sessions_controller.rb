module Public
  class SessionsController < Public::BaseController
    def new
      @form = Api::UsersService::Patients::Auth::Login.new
    end
  
    def create
      if service.call
        redirect_to root_path, notice: 'Login successful.'
      else
        redirect_to login_path, alert: service.errors.full_messages.join('<br>')
      end
    end

    def destroy
      cookies.delete(:auth_token)
      redirect_to root_path
    end

    private

    def login_params
      Auth::LoginParams.new.parse(params)
    end

    def service
      @service ||= Api::UsersService::Patients::Auth::Login.new(login_params)
    end
  end
end
