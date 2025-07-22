module Api
  class CommunicationsController < ApplicationController

    def create
      if communication_params[:communication_type].eql?('email')
        email = communication_params[:email]
        template = communication_params[:template]
        PatientMailerJob.perform_async(email:, template:)
        head :accepted
      end
    end

    private

    def communication_params
      params.require(:communication).permit(:communication_type, :email, :template)
    end
  end
end
