require 'current_account'
require_dependency 'qualify'
require_dependency 'guardian'

class ApplicationController < ActionController::API

  before_action :set_default_response_format

  include Qualify::CurrentAccount

  # Include so the jbuilder templates are rendered even by subbing ActionController::API
  include ActionController::ImplicitRender

  rescue_from Qualify::NotAuthenticated do
    render nothing: true, status: :unauthorized
  end

  def guardian
    @guardian ||= Guardian.new(current_account)
  end

  protected

  def authenticate_jwt!
    log_on_jwt(request.headers['X-Jwt-Token'])
    raise Qualify::NotAuthenticated unless current_account.present?
  end

  def set_default_response_format
    request.format = :json
  end

  def render_validation_error(model)
    render json: {
               message: I18n.t('api.create.invalid'),
               reasons: model.errors
           },
           status: :unprocessable_entity
  end
end
