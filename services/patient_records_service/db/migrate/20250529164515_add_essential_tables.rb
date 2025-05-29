class AddEssentialTables < ActiveRecord::Migration[8.0]
  def change
    create_patient_details_table
    create_diagnoses_table
    create_prescriptions_table
    create_session_notes_table
    create_documentation_table
  end

  private

  def create_patient_details_table
    create_table :patient_details do |t|
      t.bigint :patient_id, null: false
      t.string :full_name, null: false
      t.date   :date_of_birth
      t.string :gender
      t.string :contact_number
      t.text   :address

      t.timestamps
    end
    add_index :patient_details, :patient_id, unique: true
  end

  def create_diagnoses_table
    create_table :diagnoses do |t|
      t.bigint :patient_id, null: false
      t.bigint :appointment_id, null: false
      t.bigint :doctor_id
      t.string :diagnosis_code
      t.text   :description
      t.datetime :diagnosed_at, null: false

      t.timestamps
    end
    add_index :diagnoses, :appointment_id
  end

  def create_prescriptions_table
    create_table :prescriptions do |t|
      t.bigint :patient_id, null: false
      t.bigint :appointment_id, null: false
      t.bigint :doctor_id
      t.string :medication_name, null: false
      t.string :dosage
      t.string :frequency
      t.date   :start_date
      t.date   :end_date
      t.text   :notes

      t.timestamps
    end
    add_index :prescriptions, :appointment_id
  end

  def create_session_notes_table
    create_table :session_notes do |t|
      t.bigint :patient_id, null: false
      t.bigint :appointment_id, null: false
      t.bigint :doctor_id
      t.text   :content, null: false

      t.timestamps
    end
    add_index :session_notes, :appointment_id
  end

  def create_documentation_table
    create_table :documents do |t|
      t.string     :file
      t.string     :title
      t.text       :description

      t.references :documentable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :documents, [:documentable_type, :documentable_id]
  end
end
