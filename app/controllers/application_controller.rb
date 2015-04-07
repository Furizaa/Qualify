require 'current_account'

class ApplicationController < ActionController::API

  include Qualify::CurrentAccount

  before_filter :parse_request

  private

  def parse_request
    @json = JSON.parse(request.body.read)
  rescue JSON::ParserError
    @json = {}
  end
end
