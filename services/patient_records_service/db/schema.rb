# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_29_164515) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "diagnoses", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "appointment_id", null: false
    t.bigint "doctor_id"
    t.string "diagnosis_code"
    t.text "description"
    t.datetime "diagnosed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_diagnoses_on_appointment_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "file"
    t.string "title"
    t.text "description"
    t.string "documentable_type", null: false
    t.bigint "documentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable"
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id"
  end

  create_table "patient_details", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "full_name", null: false
    t.date "date_of_birth"
    t.string "gender"
    t.string "contact_number"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_patient_details_on_patient_id", unique: true
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "appointment_id", null: false
    t.bigint "doctor_id"
    t.string "medication_name", null: false
    t.string "dosage"
    t.string "frequency"
    t.date "start_date"
    t.date "end_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_prescriptions_on_appointment_id"
  end

  create_table "session_notes", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "appointment_id", null: false
    t.bigint "doctor_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_session_notes_on_appointment_id"
  end
end
