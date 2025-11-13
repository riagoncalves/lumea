module Api
  class AppointmentsController < ApplicationController
    def index
      render(status: :ok,
              json: appointments,
              each_serializer: ::AppointmentSerializer,
              root: :appointments,
              adapter: :json)
    end

    def show
      if appointment.present?
        render(status: :ok,
               json: appointment,
               serializer: ::AppointmentSerializer,
               root: :appointment,
               adapter: :json)
      else
        render(status: :not_found, json: { errors: ['Appointment not found'] })
      end
    end

    def create
      if appointment_create_service.call
        render(status: :created,
               json: appointment_create_service.appointment,
               serializer: ::AppointmentSerializer,
               root: :appointment,
               adapter: :json)
      else
        render(status: :unprocessable_entity, json: appointment_create_service, serializer: ::ErrorSerializer)
      end
    end

    def update
      if appointment_update_service.call
        render(status: :ok,
              json: appointment_update_service.appointment,
              serializer: ::AppointmentSerializer,
              root: :appointment,
              adapter: :json)
      else
        render(status: :unprocessable_entity, json: appointment_update_service, serializer: ::ErrorSerializer)
      end
    rescue ActiveRecord::RecordNotFound
      render(status: :not_found, json: { errors: ['Appointment not found'] })
    end

    def complete
      if protected_appointment&.mark_as_completed
        render(status: :ok,
              json: protected_appointment,
              serializer: ::AppointmentSerializer,
              root: :appointment,
              adapter: :json)
      else
        render(status: :unprocessable_entity, json: { errors: ['Failed to complete appointment'] })
      end
    end

    def destroy
      if protected_appointment&.destroy
        render(status: :ok,
              json: protected_appointment,
              serializer: ::AppointmentSerializer,
              root: :appointment,
              adapter: :json)
      else
        render(status: :unprocessable_entity, json: { errors: ['Failed to cancel appointment'] })
      end
    end

    private

    def appointment_create_service
      @appointment_create_service ||= Appointments::Create.new(appointment_params)
    end

    def appointment_update_service
      @appointment_update_service ||= Appointments::Update.new(update_appointment_params)
    end

    def update_appointment_params
      params.require(:appointment).permit(:start_time, :end_time, :doctor_id)
        .merge({ appointment: protected_appointment })
    end

    def appointment_params
      params.require(:appointment).permit(:start_time, :end_time, :doctor_id)
        .merge({ patient_id: current_user.id })
    end

    def appointment
      @appointment ||= if current_user.doctor?
        Appointment.find_by(id: params[:id], doctor_id: current_user.id)
      else
        Appointment.find_by(id: params[:id], patient_id: current_user.id)
      end
    end

    def protected_appointment
      return unless current_user.present?
      return @protected_appointment if defined?(@protected_appointment)

      if current_user.doctor?
        @protected_appointment = Appointment.find_by(id: params[:id], doctor_id: current_user.id)
      else
        @protected_appointment = Appointment.find_by(id: params[:id], patient_id: current_user.id)
      end

      set_log_attributes(record: @protected_appointment)
      @protected_appointment
    end

    def appointments
      @appointments ||= if current_user.doctor?
        Appointment.where(doctor_id: current_user.id).order(start_time: :desc)
      else
        Appointment.where(patient_id: current_user.id).order(start_time: :desc)
      end
    end
  end
end
