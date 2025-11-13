module Doctors
  class PatientsController < Doctors::BaseController
    def index
      if patient_details_list_service.call
        @patients = patient_details_list_service.patients
      else
        redirect_to doctor_home_path, alert: patient_details_list_service.errors.full_messages.join("<br>")
      end
    end

    def show
      if patient_details_show_service.call
        @patient = patient_details_show_service.patient
      else
        redirect_to doctor_patients_path, alert: patient_details_show_service.errors.full_messages.join("<br>")
      end
    end


    private

    def patient_details_list_service
      @patient_details_list_service ||= Api::PatientRecordsService::Doctors::PatientDetails::List.new(
        auth_token: current_token
      )
    end

    def patient_details_show_service
      @patient_details_show_service ||= Api::PatientRecordsService::Doctors::PatientDetails::Show.new(
        auth_token: current_token,
        patient_id: params[:id]
      )
    end
  end
end
