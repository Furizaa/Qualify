module Api
  class AccountsController < ApplicationController

    def create
      account = Account.new_from_params(params)
      if account.save
        return render nothing: true,
                      status: :created
      end
      render json: {
                 message: I18n.t('account.create.invalid'),
                 reasons: account.errors
             },
             status: :unprocessable_entity
    end

    def authenticate
      account = Account.find_by_email(params[:email].downcase)
      if account.present? && account.confirm_password?(params[:password])
        log_on_account(account)
        response.header['X-Jwt-Token'] = current_account_jwt
        return render nothing: true, status: :ok
      end
      render json: { message: I18n.t('authenticate.failure') }, status: :unauthorized
    end
  end
end
