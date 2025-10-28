module Doctors
  class BaseController < ApplicationController
    before_action :authenticate_doctor!

    def authenticate_doctor!
      return if doctor? && current_doctor.present?

      redirect_to doctor_login_path, alert: 'You must be logged in to access this section.'
    end

    def current_doctor
      return unless authenticated? && doctor?
      return @current_doctor if @current_doctor.present?
      return unless doctor_details_service.call

      @current_doctor ||= doctor_details_service.doctor
    end

    private

    def doctor_details_service
      @doctor_details_service ||= Api::DoctorDetailsService::Doctors::DoctorDetails::Show.new(auth_token: current_token)
    end
  end
end
