module Api
  class CommunicationsController < ApplicationController

    def create
      if communication_params[:communication_type].eql?('email')
        PatientMailerJob.perform_async(communication_params)
        head :accepted
      end
    end

    private

    def communication_params
      params.require(:communication).permit(:communication_type, :email, :template)
    end
  end
end
