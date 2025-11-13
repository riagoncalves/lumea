module Api
  class VideoCallsController < ApplicationController
    def find_or_create
      if video_room.present?
        render(status: :ok,
              json: video_room,
              serializer: ::VideoRoomSerializer,
              root: :video_room,
              adapter: :json)
      else
        if create_video_room_service.call
          render(status: :created,
                 json: create_video_room_service.video_room,
                 serializer: ::VideoRoomSerializer,
                 root: :video_room,
                 adapter: :json)
        else
          render status: :not_found, json: { errors: ['Video room not found'] }
        end
      end
    end

    private

    def create_video_room_service
      @create_video_room_service ||= VideoCalls::Create.new(
        video_call_params.merge(current_user_id: current_user.id)
      )
    end

    def video_room
      @video_room ||= VideoRoom.where.not(status: "room_ended").find_by(video_call_params)&.add_access_token(current_user.id)
    end

    def video_call_params
      {
        doctor_id: current_user.doctor? ? current_user.id : params[:recipient_id],
        patient_id: current_user.patient? ? current_user.id : params[:recipient_id],
        appointment_id: params[:appointment_id]
      }
    end
  end
end
