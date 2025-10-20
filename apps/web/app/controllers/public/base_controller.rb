module Public
  class BaseController < ApplicationController
    before_action :authenticated_redirect

    def authenticated_redirect
      return unless authenticated?

      if patient?
        redirect_to patient_home_path
      elsif doctor?
        redirect_to doctor_home_path
      end
    end
  end
end
