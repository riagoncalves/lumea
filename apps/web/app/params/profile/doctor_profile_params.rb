module Profile
  class DoctorProfileParams
    def parse(params)
      params.require(:form).permit(
        :full_name,
        :gender,
        :date_of_birth,
        :contact_number,
        :address
      ).to_h
    end
  end
end
