module AuthHelper
  def basic_login(user, pass)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(user, pass)
  end

  def save_app(app)
    session[:app] = Marshal.dump(app)
  end
end
