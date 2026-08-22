module Webhooks
  class TwilioController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      Api::VideoCallsService::Webhooks::Create.new(
        status_callback_event: params[:StatusCallbackEvent],
        room_sid: params[:RoomSid]
      ).call

      head :ok
    end
  end
end
