module Api
  module AppointmentsService
    class Base < ApplicationService
      attribute :auth_token, :string

      SERVICE_URL = ENV['APPOINTMENTS_SERVICE_URL']
    end
  end
end
