class AddEssentialTables < ActiveRecord::Migration[8.0]
  def change
    create_doctor_details_table
  end

  private

  def create_doctor_details_table
    create_table :doctor_details do |t|
      t.bigint :doctor_id, null: false
      t.string :full_name, null: false
      t.date   :date_of_birth
      t.string :gender
      t.string :contact_number
      t.text   :address

      t.timestamps
    end
    add_index :doctor_details, :doctor_id, unique: true
  end
end
