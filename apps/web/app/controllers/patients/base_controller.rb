module Patients
  class BaseController < ApplicationController
    def current_patient
      return unless authenticated?
      return @current_patient if @current_patient.present?
      return unless patient_details_service.call

      @current_patient ||= patient_details_service.patient
    end

    private

    def patient_details_service
      @patient_details_service ||= Api::PatientRecordsService::Patients::PatientDetails.new
    end
  end
end
