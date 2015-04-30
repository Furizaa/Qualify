require 'rails_helper'

RSpec.describe Api::ApiKeysController, type: :controller do

  render_views

  context 'when not authenticated' do
    it { is_expected.to use_before_action(:authenticate_jwt!) }
  end

  describe '#index' do
    context 'when authenticated as account with api access' do
      before do
        authenticate_with_jwt :account_with_api_access
        get :index
      end

      it { is_expected.to respond_with(200) }
      it { expect(response.body).to have_json_path('data/4/type') }
      it { expect(response.body).to have_json_path('data/4/key') }
      it { expect(response.body).to have_json_path('data/4/created_at') }
      it { expect(response.body).to have_json_path('data/4/updated_at') }
      it { expect(response.body).to have_json_path('data/4/links/self') }
      it { expect(response.body).to have_json_path('data/4/links/account/self') }
    end

    context 'when authenticated as account without api access' do
      before do
        authenticate_with_jwt :account
        get :index
      end

      it { is_expected.to respond_with(200) }
      it { expect(response.body).to have_json_path('data') }
      it { expect(response.body).to_not have_json_path('data/0') }
    end
  end

  describe '#create' do
    context 'when authenticated' do
      before do
        @account = authenticate_with_jwt :account
        post :create
      end

      it { is_expected.to respond_with(201) }
      it { expect(@account.api_keys.length).to be(1) }
    end
  end

  describe '#destroy' do
    context 'when authenticated as account with api access' do
      before do
        @account = authenticate_with_jwt :account_with_api_access
        delete :destroy, id: @account.api_keys.first.key
      end

      it { is_expected.to respond_with(200) }
      it { expect(@account.api_keys.length).to be(4) }
    end

    context 'when consumer tries to delete foreign key' do
      before do
        @account = authenticate_with_jwt :account_with_api_access
        delete :destroy, id: 'NOT_A_KEY_THAT_IS_FROM_THE_ACCOUNT'
      end

      it { is_expected.to respond_with(404) }
    end
  end


end
