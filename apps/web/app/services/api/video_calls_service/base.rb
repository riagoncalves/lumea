module Api
  module VideoCallsService
    class Base < ApplicationService
      SERVICE_URL = ENV['VIDEO_CALLS_SERVICE_URL']
    end
  end
end
