class CreateVideoRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :video_rooms do |t|
      t.string :name
      t.string :room_sid
      t.string :status
      t.string :access_token

      t.bigint :doctor_id, null: false
      t.bigint :patient_id, null: false

      t.timestamps
    end
  end
end
