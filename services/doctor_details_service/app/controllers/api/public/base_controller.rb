module Api
  module Public
    class BaseController < ApplicationController
      before_action :app_authentication!
    end
  end
end
