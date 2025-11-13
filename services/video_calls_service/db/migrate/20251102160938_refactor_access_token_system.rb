class RefactorAccessTokenSystem < ActiveRecord::Migration[8.0]
  def change
    remove_column :video_rooms, :access_token, :string

    create_table :video_room_access_tokens do |t|
      t.references :video_room, null: false, foreign_key: true
      t.string :access_token, null: false
      t.bigint :identity_id, null: false
      t.timestamps
    end
  end
end
