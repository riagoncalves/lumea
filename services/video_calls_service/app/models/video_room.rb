class VideoRoom < ApplicationRecord
  enum status: {
    room_created:             "room_created",
    participant_connected:    "participant_connected",
    participant_disconnected: "participant_disconnected",
    room_ended:               "room_ended"
  }
end
