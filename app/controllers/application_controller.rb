require 'current_account'
require_dependency 'qualify'

class ApplicationController < ActionController::API

  before_action :set_default_response_format

  include Qualify::CurrentAccount

  # Include so the jbuilder templates are rendered even by subbing ActionController::API
  include ActionController::ImplicitRender

  rescue_from Qualify::NotAuthenticated do
    render nothing: true, status: :unauthorized
  end

  protected

  def authenticate_jwt!
    log_on_jwt(request.headers['X-Jwt-Token'])
    raise Qualify::NotAuthenticated unless current_account.present?
  end

  def set_default_response_format
    request.format = :json
  end
end
