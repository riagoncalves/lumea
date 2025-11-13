module Api
  module VideoCallsService
    module VideoCalls
      class FindOrCreate < VideoCallsService::Base
        attribute :auth_token, :string
        attribute :recipient_id, :integer
        attribute :appointment_id, :integer

        attr_reader :video_room

        def call
          return false if auth_token.blank?

          response = Faraday.post(url) do |req|
            req.headers['Authorization'] = auth_token
          end

          handle_response(response)
        end

        private

        def url
          "#{SERVICE_URL}/video_calls/#{appointment_id}/#{recipient_id}"
        end

        def handle_response(response)
          return handle_success(response) if response.success?
          
          if response.body["errors"].present?
            response.body["errors"].each do |error|
              errors.add(:base, error)
            end
          else
            errors.add(:base, "Unexpected error occurred.")
          end

          false
        end

        def handle_success(response)
          video_room_details = response.body["video_room"]

          @video_room = VideoRoom.new(
            id: video_room_details["id"],
            name: video_room_details["name"],
            status: video_room_details["status"],
            doctor_id: video_room_details["doctor_id"],
            patient_id: video_room_details["patient_id"],
            appointment_id: video_room_details["appointment_id"],
            access_token: video_room_details["access_token"],
            room_sid: video_room_details["room_sid"]
          )

          true
        end
      end
    end
  end
end
