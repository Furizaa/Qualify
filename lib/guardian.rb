class Guardian
  def initialize(account)
    @account = account
  end

  def can_view_schema?(schema)
    is_owner_of?(schema)
  end

  private

  def is_owner_of?(obj)
    return obj.account_id == @account.id if obj.respond_to?(:account_id) && @account.id && obj.account_id
    obj.account == @account if obj.respond_to?(:account)
  end
end
