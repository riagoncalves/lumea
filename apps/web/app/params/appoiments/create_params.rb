module Appointments
  class CreateParams
    def parse(params)
      params.require(:form).permit(
        :start_time,
        :end_time,
        :doctor_id,
      ).to_h
    end
  end
end
