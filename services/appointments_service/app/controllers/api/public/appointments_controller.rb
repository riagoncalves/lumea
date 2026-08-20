module Api
  module Public
    class AppointmentsController < BaseController
      def show
        render(status: :ok,
               json: { can_start_video_call: appointment.can_start_video_call? },
               root: false)
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Appointment not found'] })
      end

      private

      def appointment
        @appointment ||= Appointment.find(params[:id])
      end
    end
  end
end
