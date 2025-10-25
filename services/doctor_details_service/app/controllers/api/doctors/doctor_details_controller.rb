module Api
  module Doctors
    class DoctorDetailsController < BaseController
      def show
        if current_user.present?
          render(status: :ok,
                json: doctor_detail,
                serializer: ::DoctorDetailsSerializer,
                root: :doctor_detail,
                adapter: :json)
        else
          render(status: :not_found, json: { errors: ['Doctor not found or is not a valid doctor'] })
        end
      end
  
      def update
        if current_user.present?
          if doctor_detail.update(doctor_detail_params)
            render(status: :ok,
                  json: doctor_detail,
                  serializer: ::DoctorDetailsSerializer,
                  root: :doctor_detail,
                  adapter: :json)
          else
            render(status: :unprocessable_entity, json: { errors: doctor_detail.errors.full_messages })
          end
        else
          render(status: :not_found, json: { errors: ['Doctor not found or is not a valid doctor'] })
        end
      rescue ActiveRecord::RecordNotFound
        render(status: :not_found, json: { errors: ['Doctor detail not found'] })
      end
  
      private
  
      def doctor_detail
        @doctor_detail ||= DoctorDetail.find_or_initialize_by(doctor_id: current_user.id)
      end
  
      def doctor_detail_params
        params.require(:doctor_detail).permit(:full_name, :gender, :date_of_birth, :contact_number, :address)
      end
    end
  end
end
