module Api
  class VideoCallsController < ApplicationController
    before_action :set_video_room, only: [:show]

    def create
      service = VideoCalls::Create.new(video_call_create_params)
      if service.call
        render(status: :ok,
              json: service.video_room,
              serializer: ::VideoRoomSerializer,
              root: :video_room,
              adapter: :json)
      else
        render(status: :unprocessable_entity, json: service, serializer: ::ErrorSerializer)
      end
    end

    def show
      if @video_room.present?
        render(status: :ok,
              json: @video_room,
              serializer: ::VideoRoomSerializer,
              root: :video_room,
              adapter: :json)
      else
        render status: :not_found, json: { errors: ['Video room not found'] }
      end
    end

    private

    def video_call_create_params
      params.require(:video_call).permit(:doctor_id, :patient_id)
    end

    def set_video_room
      @video_room = VideoRoom.find_by(room_sid: params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: { errors: ['Video room not found'] }
    end
  end
end
