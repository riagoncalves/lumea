class PatientDetail < ApplicationRecord
  enum :gender, {
    male: 'male',
    female: 'female',
    other: 'other'
  }
end
