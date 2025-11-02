class VideoRoom < ApplicationRecord
  attr_reader :access_token

  has_many :video_room_access_tokens, dependent: :destroy

  enum :status, {
    room_created: "room_created",
    participant_connected: "participant_connected",
    participant_disconnected: "participant_disconnected",
    room_ended: "room_ended"
  }

  def add_access_token(identity_id)
    video_room_token = video_room_access_tokens.find_or_initialize_by(identity_id:)
    if video_room_token.access_token.blank?
      video_room_token.update!(access_token: generate_video_token(identity_id))
    end

    @access_token = video_room_token.access_token
    self
  end

  private

  def generate_video_token(identity_id)
    token = Twilio::JWT::AccessToken.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_API_KEY_SID'],
      ENV['TWILIO_API_KEY_SECRET'],
      identity: identity_id.to_s
    )
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = name
    token.add_grant(grant)
    token.to_jwt
  end
end
