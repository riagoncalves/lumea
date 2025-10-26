module Patients
  class AppointmentsController < Patients::BaseController
    before_action :set_doctors_list, only: %i[new edit]

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
        redirect_to patient_appointments_path, alert: service.errors.full_messages.join('<br>')
      end
    end

    def new
      @form = Api::AppointmentsService::Appointments::Create.new
    end

    def create
      if create_appointment_service.call
        redirect_to patient_appointments_path, notice: 'Appointment created successfully.'
      else
        redirect_to patient_new_appointment_path, alert: create_appointment_service.errors.full_messages.join('<br>')
      end
    end

    def edit
      service = Api::AppointmentsService::Appointments::Show.new(
        auth_token: current_token,
        id: params[:id]
      )

      if service.call
        @appointment = service.appointment
        @form = Appointments::UpdateParams.new(
          id: @appointment.id,
          doctor_id: @appointment.doctor_id,
          start_time: @appointment.start_time,
          end_time: @appointment.end_time
        )
      else
        redirect_to patient_appointments_path, alert: service.errors.full_messages.join('<br>')
      end
    end

    def update
      if update_appointment_service.call
        redirect_to patient_appointment_path(params[:id]), notice: 'Appointment updated successfully.'
      else
        redirect_to edit_patient_appointment_path(params[:id]), alert: update_appointment_service.errors.full_messages.join('<br>')
      end
    end

    def complete
      if complete_appointment_service.call
        redirect_to patient_appointment_path(params[:id]), notice: 'Appointment completed successfully.'
      else
        redirect_to patient_appointment_path(params[:id]), alert: complete_appointment_service.errors.full_messages.join('<br>')
      end

    end

    def destroy
      if cancel_appointment_service.call
        redirect_to patient_appointments_path, notice: 'Appointment cancelled successfully.'
      else
        redirect_to patient_appointments_path, alert: cancel_appointment_service.errors.full_messages.join('<br>')
      end
    end

    private

    def set_doctors_list
      @doctors_list = if doctor_details_service.call
                        doctor_details_service.doctors
                      else
                        []
                      end
    end

    def doctor_details_service
      @doctor_details_service ||= Api::DoctorDetailsService::DoctorDetails::List.new
    end

    def create_appointment_service
      @create_appointment_service ||= Api::AppointmentsService::Appointments::Create.new(create_params)
    end

    def update_appointment_service
      @update_appointment_service ||= Api::AppointmentsService::Appointments::Update.new(update_params)
    end

    def complete_appointment_service
      @complete_appointment_service ||= Api::AppointmentsService::Appointments::Complete.new(
        id: params[:id],
        auth_token: current_token
      )
    end

    def cancel_appointment_service
      @cancel_appointment_service ||= Api::AppointmentsService::Appointments::Cancel.new(
        id: params[:id],
        auth_token: current_token
      )
    end

    def create_params
      Appointments::CreateParams.new.parse(params).merge(
        auth_token: current_token
      )
    end

    def update_params
      Appointments::UpdateParams.new.parse(params).merge(
        auth_token: current_token
      )
    end
  end
end
