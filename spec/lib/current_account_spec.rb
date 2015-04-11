require 'rails_helper'
require 'current_account'

RSpec.configure do |config|
  config.include Qualify::CurrentAccount
end

RSpec.describe 'CurrentAccount' do

  let(:account) { FactoryGirl.create(:account) }

  let(:jwt) do
    log_on_account(account)
    current_account_jwt
  end

  it 'handles current account model' do
    log_on_account(account)
    expect(current_account).to eq(account)
  end

  it 'generates jwt from account' do
    log_on_account(account)
    expect(current_account_jwt.split('.').first).to eq('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9')
  end

  it 'logs on user from token' do
    log_off_account
    expect(current_account.present?).to be_falsey
    account.save!
    log_on_jwt(jwt)
    expect(current_account.present?).to be_truthy
  end
end
