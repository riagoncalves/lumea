module ExternalServices
  # Fetches doctor/patient details for a list of appointments once per unique ID,
  # concurrently, instead of once per appointment row. Ruby releases the GIL
  # around blocking I/O, so N distinct HTTP calls run in roughly the time of the
  # single slowest one instead of N times that.
  class PrefetchAppointmentDetails
    def initialize(appointments)
      @appointments = appointments
    end

    def call
      doctor_ids = @appointments.map(&:doctor_id).uniq
      patient_ids = @appointments.map(&:patient_id).uniq

      doctor_threads = doctor_ids.map { |id| Thread.new { [id, fetch_doctor(id)] } }
      patient_threads = patient_ids.map { |id| Thread.new { [id, fetch_patient(id)] } }

      @doctor_details_by_id = doctor_threads.map(&:value).to_h
      @patient_details_by_id = patient_threads.map(&:value).to_h

      self
    end

    attr_reader :doctor_details_by_id, :patient_details_by_id

    private

    def fetch_doctor(id)
      service = ExternalServices::DoctorDetailsService::Show.new(doctor_id: id)
      service.call ? service.doctor : {}
    rescue StandardError => e
      Rails.logger.error("Failed to prefetch doctor #{id}: #{e.message}")
      {}
    end

    def fetch_patient(id)
      service = ExternalServices::PatientRecordsService::PatientDetails::Show.new(patient_id: id)
      service.call ? service.patient : {}
    rescue StandardError => e
      Rails.logger.error("Failed to prefetch patient #{id}: #{e.message}")
      {}
    end
  end
end
