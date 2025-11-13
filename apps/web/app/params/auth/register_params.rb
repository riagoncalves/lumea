module Auth
  class RegisterParams
    def parse(params)
      params.require(:form).permit(
        :email,
        :password,
        :password_confirmation
      ).to_h
    end
  end
end
