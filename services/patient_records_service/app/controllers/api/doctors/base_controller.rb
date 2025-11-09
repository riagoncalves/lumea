module Api
  module Doctors
    class BaseController < ApplicationController
      before_action :require_doctor!

      private

      def set_patient
        return unless params[:id].present?

        user = ::ExternalServices::UsersService.get_user(params[:id])
        return unless user&.patient?

        @patient = user
      rescue UserNotFound
        raise ActiveRecord::RecordNotFound, 'Patient not found'
      rescue Unauthorized
        render(status: :unauthorized, json: { errors: ['Unauthorized access'] })
      rescue StandardError => e
        render(status: :internal_server_error, json: { errors: [e.message] })
      end

      def auth_token
        request.headers['Authorization']
      end
    end
  end
end
