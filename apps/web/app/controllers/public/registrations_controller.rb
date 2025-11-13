module Public
  class RegistrationsController < Public::BaseController
    def new
      @form = Api::UsersService::Patients::Auth::Register.new
    end
  
    def create
      if service.call
        redirect_to login_path, notice: 'Registration successful.'
      else
        redirect_to register_path, alert: service.errors.full_messages.join('<br>')
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
