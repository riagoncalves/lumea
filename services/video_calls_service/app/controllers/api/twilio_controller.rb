module Api
  class TwilioController < ApplicationController
    skip_before_action :authenticate_user!, only: [:webhook]
    skip_before_action :set_log_attributes, only: [:webhook]

    def webhook
      event   = params[:StatusCallbackEvent]
      room_id = params[:RoomSid]
      video_room = VideoRoom.find_by(room_sid: room_id)
      video_room&.update(status: event)

      head :ok
    end
  end
end
