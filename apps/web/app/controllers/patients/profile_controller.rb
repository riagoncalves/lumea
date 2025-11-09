module Patients
  class ProfileController < Patients::BaseController
    def show
      unless patient_details_show_service.call
        redirect_to patient_home_path, alert: 'Unable to load profile details.'
        return
      end

      @profile = patient_details_show_service.patient
    end

    def edit
      unless patient_details_show_service.call
        redirect_to patient_home_path, alert: 'Unable to load profile details.'
        return
      end

      @profile = patient_details_show_service.patient
    end

    def update
      if patient_details_update_service.call
        redirect_to patient_profile_path, notice: 'Profile updated successfully.'
      else
        redirect_to patient_profile_path, alert: patient_details_update_service.errors.full_messages.join('<br>')
      end
    end

    private

    def update_params
      @update_params ||= Profile::PatientProfileParams.new.parse(params).merge(
        auth_token: current_token
      )
    end

    def patient_details_update_service
      @patient_details_update_service ||= Api::PatientRecordsService::Patients::PatientDetails::Update.new(
        update_params
      )
    end

    def patient_details_show_service
      @patient_details_show_service ||= Api::PatientRecordsService::Patients::PatientDetails::Show.new(
        auth_token: current_token
      )
    end
  end
end
