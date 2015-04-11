module Qualify
  module CurrentAccount

    def log_on_jwt(token)
      if token
        begin
          payload = JWT.decode(token, 'current_account_id')
          @current_account = Account.find(payload.first['id'])
        rescue JWT::DecodeError
          @current_account = nil
        end
      end
    end

    def current_account_jwt
      if @current_account && @current_account.id
        JWT.encode({ 'id' => @current_account.id }, 'current_account_id')
      end
    end

    def current_account
      @current_account
    end

    def log_on_account(current_account)
      @current_account = current_account
    end

    def log_off_account
      @current_account = nil
    end

  end
end
