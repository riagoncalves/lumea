module Public
  class HomeController < Public::BaseController
    def index
      redirect_to login_path
    end
  end
end
