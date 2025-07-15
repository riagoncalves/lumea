class PatientDetail < ApplicationRecord
  include Loggable

  enum :gender, {
    male: 'male',
    female: 'female',
    other: 'other'
  }
end
