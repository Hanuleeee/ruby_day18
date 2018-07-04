class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def js_authenticate_user!
      render js: "location.href='/users/sign_in';" unless user_signed_in?  # js코드자체를 응답으로 취함
      #redirect_to는 get방식으로 또다른 url로 이동시킴(render와 비슷)
  end
end
