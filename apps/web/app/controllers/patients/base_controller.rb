module Patients
  class BaseController < ApplicationController
    before_action :authenticate_patient!

    def authenticate_patient!
      return if patient? && current_patient.present?

      redirect_to login_path, alert: 'You must be logged in to access this section.'
    end

    def current_patient
      return unless authenticated? && patient?
      return @current_patient if @current_patient.present?
      return unless patient_details_service.call

      @current_patient ||= patient_details_service.patient
    end

    private

    def patient_details_service
      @patient_details_service ||= Api::PatientRecordsService::Patients::PatientDetails.new(auth_token: current_token)
    end
  end
end
