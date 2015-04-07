require 'rails_helper'

RSpec.describe AccountsController, type: :controller do

  describe '.create' do
    it 'creates account' do
      post :create, ActiveSupport::JSON.encode({ email: 'valid@qualify.ch', password: 'secret' })
      expect(response.status).to eq(201), response.body
      expect(Account.find_by_email('valid@qualify.ch').present?).to be_truthy
    end

    it 'returns 422 on invalid email' do
      post :create, ActiveSupport::JSON.encode({ email: '', password: 'secret' })
      expect(response.status).to eq(422), response.body
      expect(response.body).to have_json_path('reasons/email')
    end

    it 'returns 422 on invalid password' do
      post :create, ActiveSupport::JSON.encode({ email: 'valid2@qualify.ch', password: 'sec' })
      expect(response.status).to eq(422), response.body
      expect(response.body).to have_json_path('reasons/password')
    end

    it 'returns 422 on malformed request' do
      post :create, ActiveSupport::JSON.encode({})
      expect(response.status).to eq(422), response.body
      expect(response.body).to have_json_path('reasons/email')
    end
  end

  describe '.authenticate' do
    before :each do
      post :create, ActiveSupport::JSON.encode({ email: 'valid@qualify.ch', password: 'secret' })
    end

    it 'returns 401 on invalid email' do
      get :authenticate, { email: 'invalid@qualify.ch', password: 'secret' }
      expect(response.status).to eq(401), response.body
    end

    it 'returns 401 on invalid password' do
      get :authenticate, { email: 'valid@qualify.ch', password: 'wrong!' }
      expect(response.status).to eq(401), response.body
    end

    it 'returns 200 OK with token on valid credentials' do
      get :authenticate, { email: 'valid@qualify.ch', password: 'secret' }
      expect(response.status).to eq(200), response.body
      expect(response.header.has_key?('X-Jwt-Token')).to be_truthy
    end
  end

end