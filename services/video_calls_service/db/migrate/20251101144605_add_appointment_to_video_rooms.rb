class AddAppointmentToVideoRooms < ActiveRecord::Migration[8.0]
  def change
    add_column :video_rooms, :appointment_id, :bigint, null: false
  end
end
