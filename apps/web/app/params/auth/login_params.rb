module Auth
  class LoginParams
    def parse(params)
      params.require(:form).permit(
        :email,
        :password,
      ).to_h
    end
  end
end
