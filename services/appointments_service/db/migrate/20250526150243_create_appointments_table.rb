class CreateAppointmentsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.bigint :doctor_id, null: false  # or :uuid if that's what you're using
      t.bigint :patient_id, null: false

      t.datetime :start_time, null: false
      t.datetime :end_time

      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :appointments, :doctor_id
    add_index :appointments, :patient_id
  end
end
