module Api
  module Public
    class DoctorDetailsController < BaseController
      def index
        render(status: :ok,
              json: doctor_details,
              each_serializer: ::DoctorDetailsMinimalSerializer,
              root: :doctor_details,
              adapter: :json)
      end

      def show
        render(status: :ok,
              json: doctor_detail,
              serializer: ::DoctorDetailsSerializer,
              root: :doctor_detail,
              adapter: :json)
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Doctor detail not found'] })
      end

      private

      def doctor_detail
        @doctor_detail ||= DoctorDetail.find_or_initialize_by(doctor_id: params[:doctor_id])
      end

      def doctor_details_params
        params.fetch(:doctor_details, {}).permit(doctor_ids: [])
      end

      def doctor_details
        @doctor_details ||= if doctor_details_params[:doctor_ids].blank?
                             DoctorDetail.all
                           else
                            DoctorDetail.where(doctor_id: doctor_details_params[:doctor_ids])
                           end
      end
    end
  end
end
