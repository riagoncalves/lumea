module Api
  module Public
    class BaseController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :app_authentication!
    end
  end
end
