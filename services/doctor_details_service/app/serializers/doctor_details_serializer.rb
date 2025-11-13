class DoctorDetailsSerializer < ApplicationSerializer
  attributes :doctor_id, :full_name, :gender, :date_of_birth, :contact_number, :address
end
