module Api
  class VideoCallsController < ApplicationController
    def create
      
    end

    def show
      render(status: :ok,
            json: patient_detail,
            serializer: ::PatientDetailsSerializer,
            root: :patient_detail,
            adapter: :json)
    rescue ActiveRecord::RecordNotFound
      render(status: :not_found, json: { errors: ['Patient detail not found'] })
    end

    def update
      if patient_detail.update(patient_detail_params)
        render(status: :ok,
              json: patient_detail,
              serializer: ::PatientDetailsSerializer,
              root: :patient_detail,
              adapter: :json)
      else
        render(status: :unprocessable_entity, json: { errors: patient_detail.errors.full_messages })
      end
    rescue ActiveRecord::RecordNotFound
      render(status: :not_found, json: { errors: ['Patient detail not found'] })
    end

    private

    def video_call
    end

    def generate_video_token(identity, room_sid)
      # Setup token
      token = Twilio::JWT::AccessToken.new(
        ENV['TWILIO_ACCOUNT_SID'],
        ENV['TWILIO_API_KEY_SID'],
        ENV['TWILIO_API_KEY_SECRET'],
        identity: identity
      )

      # Attach a VideoGrant
      grant = Twilio::JWT::AccessToken::VideoGrant.new
      grant.room = room_sid
      token.add_grant(grant)

      # Return the signed JWT
      token.to_jwt
    end

    def find_or_create_room(name)
      # Try to fetch an existing room with this name
      existing = TwilioClient.video.rooms.list(unique_name: name)&.first
      return existing if existing.present?

      # Otherwise create the room
      TwilioClient.video.rooms.create(
        unique_name: name,
        type: 'group',          # or 'group-small', 'go', etc
        record_participants_on_connect: false
      )
    end
  end
end
