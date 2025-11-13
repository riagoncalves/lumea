module Doctors
  class ProfileController < Doctors::BaseController
    def show
      unless doctor_details_show_service.call
        redirect_to doctor_home_path, alert: 'Unable to load profile details.'
        return
      end

      @profile = doctor_details_show_service.doctor
    end

    def edit
      unless doctor_details_show_service.call
        redirect_to doctor_home_path, alert: 'Unable to load profile details.'
        return
      end

      @profile = doctor_details_show_service.doctor
    end

    def update
      if doctor_details_update_service.call
        redirect_to doctor_profile_path, notice: 'Profile updated successfully.'
      else
        redirect_to doctor_profile_path, alert: doctor_details_update_service.errors.full_messages.join('<br>')
      end
    end

    private

    def update_params
      @update_params ||= Profile::DoctorProfileParams.new.parse(params).merge(
        auth_token: current_token
      )
    end

    def doctor_details_update_service
      @doctor_details_update_service ||= Api::DoctorDetailsService::Doctors::DoctorDetails::Update.new(
        update_params
      )
    end

    def doctor_details_show_service
      @doctor_details_show_service ||= Api::DoctorDetailsService::Doctors::DoctorDetails::Show.new(auth_token: current_token)
    end
  end
end
