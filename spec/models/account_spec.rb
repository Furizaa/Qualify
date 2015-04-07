require 'rails_helper'

RSpec.describe Account, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:account)).to be_valid
  end

  it 'is invalid without an email' do
    expect(FactoryGirl.build(:account, email: nil)).to_not be_valid
  end

  %w(@gmail.com mail@ gmail.com).each do |badmail|
    it "is invalid with email #{badmail}" do
      expect(FactoryGirl.build(:account, email: badmail)).to_not be_valid
    end
  end

  it 'always downcases email' do
    account = FactoryGirl.build(:account, email: 'FOO@baR.CH')
    expect(account.email).to eq('foo@bar.ch')
  end

  it 'can be instanced from params' do
    params = { email: 'developer@qualify.com', password: 'secret' }
    account = Account.new_from_params(params)
    expect(account.email).to eq(params['email'])
  end

  describe 'password' do

    let(:account) { FactoryGirl.create(:account) }

    it 'can be confirmed' do
      account.password = 'nyancat'
      account.save!
      expect(account.confirm_password?('nyancat')).to be_truthy
    end

    it 'can be revoked' do
      account.password = 'nyancat'
      account.save!
      expect(account.confirm_password?('nyancat_')).to be_falsey
    end

    it 'is hashed after initial save' do
      account.password = 'nyancat'
      account.save!
      expect(account.password_hash.length).to eq(64)
    end

    it 'needs more than 5 characters to be validated' do
      account.password = '12345'
      expect(account).to_not be_valid
    end

  end

end
