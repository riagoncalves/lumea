module Api
  module Doctors
    class BaseController < ApplicationController
      before_action :app_authentication!
    end
  end
end
