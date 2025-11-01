module VideoCalls
  class Create < ApplicationService
    attribute :doctor_id, :integer
    attribute :patient_id, :integer
    attribute :appointment_id, :integer

    attr_reader :video_room

    def call
      twilio_room = find_or_create_room
      find_or_create_video_room(twilio_room)
    end

    private

    def room_name
      @room_name ||= "doctor_#{doctor_id}_patient_#{patient_id}"
    end

    def find_or_create_room
      existing = TwilioClient.video.rooms.list(unique_name: room_name)&.first
      return existing if existing.present?

      TwilioClient.video.rooms.create(
        unique_name: room_name,
        type: 'group'
      )
    end

    def find_or_create_video_room(twilio_room)
      @video_room = VideoRoom.find_or_create_by(room_sid: twilio_room.sid) do |vr|
        vr.name = room_name
        vr.status = "room_created"
        vr.doctor_id = doctor_id
        vr.patient_id = patient_id
        vr.appointment_id = appointment_id
        vr.access_token = generate_video_token(patient_id, twilio_room.unique_name)
      end
    end

    def generate_video_token(identity, unique_name)
      token = Twilio::JWT::AccessToken.new(
        ENV['TWILIO_ACCOUNT_SID'],
        ENV['TWILIO_API_KEY_SID'],
        ENV['TWILIO_API_KEY_SECRET'],
        identity: identity.to_s
      )
      grant = Twilio::JWT::AccessToken::VideoGrant.new
      grant.room = unique_name
      token.add_grant(grant)
      token.to_jwt
    end
  end
end
