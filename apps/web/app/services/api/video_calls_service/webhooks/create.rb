module Api
  module VideoCallsService
    module Webhooks
      class Create < VideoCallsService::Base
        INTERNAL_API_SECRET = ENV["APP_SECRET_KEY"]

        attribute :status_callback_event, :string
        attribute :room_sid, :string

        def call
          return false if INTERNAL_API_SECRET.blank?

          response = Faraday.post(url) do |req|
            req.headers['Authorization'] = INTERNAL_API_SECRET
            req.body = {
              StatusCallbackEvent: status_callback_event,
              RoomSid: room_sid
            }
          end

          response.success?
        end

        private

        def url
          "#{SERVICE_URL}/twilio/webhook"
        end
      end
    end
  end
end
