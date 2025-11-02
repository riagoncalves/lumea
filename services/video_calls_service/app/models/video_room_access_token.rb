class VideoRoomAccessToken < ApplicationRecord
  belongs_to :video_room

  validates :access_token, presence: true
  validates :identity_id, presence: true
end
