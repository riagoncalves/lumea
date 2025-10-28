module Doctors
  class AppointmentsController < Doctors::BaseController
    def index
      service = Api::AppointmentsService::Appointments::List.new(auth_token: current_token)
      if service.call
        @appointments = service.appointments
      else
        @appointments = []
        flash.now[:alert] = service.errors.full_messages.join('<br>')
      end
    end

    def show
      service = Api::AppointmentsService::Appointments::Show.new(
        auth_token: current_token,
        id: params[:id]
      )
      if service.call
        @appointment = service.appointment
      else
        redirect_to doctor_appointments_path, alert: service.errors.full_messages.join('<br>')
      end
    end

    def complete
      if complete_appointment_service.call
        redirect_to doctor_appointment_path(params[:id]), notice: 'Appointment completed successfully.'
      else
        redirect_to doctor_appointment_path(params[:id]), alert: complete_appointment_service.errors.full_messages.join('<br>')
      end

    end

    def destroy
      if cancel_appointment_service.call
        redirect_to doctor_appointments_path, notice: 'Appointment cancelled successfully.'
      else
        redirect_to doctor_appointments_path, alert: cancel_appointment_service.errors.full_messages.join('<br>')
      end
    end
  end
end
