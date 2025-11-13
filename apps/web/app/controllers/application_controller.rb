class ApplicationController < ActionController::Base
  include AuthHelper
  helper_method :current_patient, :current_doctor

  allow_browser versions: :modern

  def current_patient
    nil
  end

  def current_doctor
    nil
  end
end
