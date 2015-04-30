require 'rails_helper'

RSpec.describe Api::AccountsController, type: :controller do

  describe '.create' do

    context 'when supplied with valid params' do

      before do
        post :create, { email: 'valid@qualify.ch', password: 'secret' }
      end

      it { is_expected.to respond_with 201 }
      it { expect(Account.find_by_email('valid@qualify.ch').present?).to be_truthy }
    end

    context 'when supplied with invalid email' do
      before do
        post :create, { email: '', password: 'secret' }
      end

      it { is_expected.to respond_with 422 }
      it { expect(response.body).to have_json_path('reasons/email') }
      it { expect(json_response['reasons']['email'].first).to match /not valid/ }
    end

    context 'when supplied with invalid password' do
      before do
        post :create, { email: 'valid2@qualify.ch', password: 'sec' }
      end

      it { is_expected.to respond_with 422 }
      it { expect(response.body).to have_json_path('reasons/password') }
    end

    context 'when supplied with malformed request' do
      before do
        post :create, {}
      end
      it { is_expected.to respond_with 422 }
      it { expect(response.body).to have_json_path('reasons/email') }
      it { expect(json_response['reasons']['email'].first).to match /not valid/ }
    end

    context 'when the same account is created twice' do
      before do
        post :create, { email: 'valid@qualify.ch', password: 'secret' }
        post :create, { email: 'valid@qualify.ch', password: 'secret' }
      end

      it { is_expected.to respond_with 422 }
      it { expect(response.body).to have_json_path('reasons/email') }
      it { expect(json_response['reasons']['email'].first).to match /taken/ }
    end
  end

  describe '.authenticate' do
    before do
      post :create, { email: 'valid@qualify.ch', password: 'secret' }
    end

    it 'returns 401 on invalid email' do
      get :authenticate, { email: 'invalid@qualify.ch', password: 'secret' }
      expect(response.status).to eq(401), response.body
    end

    it 'returns 401 on invalid password' do
      get :authenticate, { email: 'valid@qualify.ch', password: 'wrong!' }
      expect(response.status).to eq(401), response.body
    end

    context 'when credentials are valid' do
      before do
        get :authenticate, { email: 'valid@qualify.ch', password: 'secret' }
      end
      it { is_expected.to respond_with 200 }
      it { expect(response.header.has_key?('X-Jwt-Token')).to be_truthy }
    end
  end

end
