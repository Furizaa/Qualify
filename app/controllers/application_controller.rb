require 'current_account'

class ApplicationController < ActionController::API

  include Qualify::CurrentAccount

end
