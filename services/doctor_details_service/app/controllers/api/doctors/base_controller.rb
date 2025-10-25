module Api
  module Doctors
    class BaseController < ApplicationController
      before_action :authenticate_user!
      before_action :require_doctor!
    end
  end
end
