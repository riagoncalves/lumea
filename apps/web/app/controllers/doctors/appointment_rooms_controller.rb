module Doctors
  class AppointmentRoomsController < Doctors::BaseController
    def show
      if appointment_details_service.call
        @appointment = appointment_details_service.appointment
        if @appointment.can_join_room?
          if video_calls_find_or_create_service.call
            @video_room = video_calls_find_or_create_service.video_room
          else
            redirect_to doctor_appointment_path(@appointment.id), alert: video_calls_find_or_create_service.errors.full_messages.join('<br>')
          end
        else
          redirect_to doctor_appointment_path(@appointment.id), alert: 'Video call cannot be started at this time.'
        end
      else
        redirect_to doctor_appointments_path, alert: appointment_details_service.errors.full_messages.join('<br>')
      end
    end

    private

    def appointment_details_service
      @appointment_details_service ||= Api::AppointmentsService::Appointments::Show.new(
        auth_token: current_token,
        id: params[:id]
      )
    end

    def video_calls_find_or_create_service
      @video_calls_find_or_create_service ||= Api::VideoCallsService::VideoCalls::FindOrCreate.new(
        auth_token: current_token,
        recipient_id: @appointment.patient_id,
        appointment_id: params[:id]
      )
    end
  end
end
