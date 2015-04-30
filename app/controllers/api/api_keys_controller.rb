module Api
  class ApiKeysController < ApplicationController

    before_action :authenticate_jwt!

    def index
      @api_keys = current_account.api_keys
    end

    def create
      current_account.add_api_key
      current_account.save!
      render nothing: true, status: :created
    end

    def destroy
      @api_key = current_account.api_keys.find_by_key(params[:id])
      if @api_key.present?
        current_account.api_keys.delete(@api_key)
        render nothing: true, status: :ok
      else
        render nothing: true, status: :not_found
      end
    end
  end
end
