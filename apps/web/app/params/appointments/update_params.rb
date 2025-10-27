module Appointments
  class UpdateParams
    def parse(params)
      params.require(:form).permit(
        :start_time,
        :end_time,
        :doctor_id,
      ).to_h.merge(
        id: params[:id]
      )
    end
  end
end
