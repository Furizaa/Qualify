require 'current_account'
require_dependency 'qualify'

class ApplicationController < ActionController::API

  include Qualify::CurrentAccount

  # Include so the jbuilder templates are rendered
  include ActionController::ImplicitRender

  respond_to :json

  def authenticate_jwt!
    log_on_jwt(request.headers['X-Jwt-Token'])
    raise Qualify::NotAuthenticated unless current_account.present?
  end

  rescue_from Qualify::NotAuthenticated do
    render nothing: true, status: :unauthorized
  end
end
