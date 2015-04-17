require 'rails_helper'

RSpec.describe Api::V1::SchemasController, type: :controller do

  render_views

  context 'when not authenticated' do
    it { is_expected.to use_before_action(:authenticate_jwt!) }
  end

  context 'when authenticated' do
    before do
      @account = authenticate_with_jwt :account
    end

    describe '#create' do
      context 'with sufficent parameters' do
        before do
          post :create, { schema: { name: 'testschema' } }
        end

        it { is_expected.to respond_with(201) }
        it { expect(Schema.all.length).to be(1) }
        it { expect(response.body).to have_json_path('data/type') }
        it { expect(response.body).to have_json_path('data/id') }
        it { expect(response.body).to have_json_path('data/name') }
        it { expect(response.body).to have_json_path('data/links/self') }
        end

      context 'with insufficient parameters' do
        before do
          post :create, { schema: { } }
        end

        it { is_expected.to respond_with(422) }
        it { expect(Schema.all.length).to be(0) }
      end
    end

    describe '#destroy' do
      context 'when account owns the schema' do
        let(:schema) { FactoryGirl.create(:schema, account: @account) }
        before do
          delete :destroy, { id: schema.uuid }
        end

        it { is_expected.to respond_with(204) }
        it { expect(Schema.all.length).to be(0) }
      end

      context 'when account does not own the schema' do
        let(:schema) { FactoryGirl.create(:schema) }
        before do
          delete :destroy, { id: schema.uuid }
        end

        it { is_expected.to respond_with(404) }
      end

      context 'when schema does not exist' do
        before do
          delete :destroy, { id: 'does_not_exist' }
        end

        it { is_expected.to respond_with(404) }
      end
    end

    describe '#show' do
      context 'when account owns the schema' do
        let(:schema) { FactoryGirl.create(:schema, account: @account) }
        before do
          get :show, { id: schema.uuid }
        end

        it { is_expected.to respond_with(200) }
        it { expect(response.body).to have_json_path('data/type') }
        it { expect(response.body).to have_json_path('data/id') }
        it { expect(response.body).to have_json_path('data/name') }
        it { expect(response.body).to have_json_path('data/links/self') }
      end

      context 'when account does not own the schema' do
        let(:schema) { FactoryGirl.create(:schema) }
        before do
          get :show, { id: schema.uuid }
        end

        it { is_expected.to respond_with(404) }
      end

      context 'when schema does not exist' do
        before do
          get :show, { id: 'does_not_exist' }
        end

        it { is_expected.to respond_with(404) }
      end
    end

    describe '#update' do
      context 'when account owns the schema' do
        let(:schema) { FactoryGirl.create(:schema, account: @account) }
        before do
          put :update, { id: schema.uuid, name: 'new name' }
        end

        it { is_expected.to respond_with(200) }
        it { expect(response.body).to have_json_path('data/type') }
        it { expect(response.body).to have_json_path('data/id') }
        it { expect(response.body).to have_json_path('data/name') }
        it { expect(response.body).to have_json_path('data/links/self') }
        it 'has the new name' do
          schema.reload
          expect(schema.name).to eq('new name')
        end
      end

      context 'when attributes are invalid' do
        let(:schema) { FactoryGirl.create(:schema, account: @account) }
        before do
          put :update, { id: schema.uuid, name: '' }
        end

        it { is_expected.to respond_with(422) }
      end

      context 'when account does not own the schema' do
        let(:schema) { FactoryGirl.create(:schema) }
        before do
          put :update, { id: schema.uuid, name: 'new name' }
        end

        it { is_expected.to respond_with(404) }
      end

      context 'when schema does not exist' do
        before do
          put :update, { id: 'does_not_exist' }
        end

        it { is_expected.to respond_with(404) }
      end
    end

    describe '#index' do
      before do
        FactoryGirl.create(:schema, account: @account)
        FactoryGirl.create(:schema)
        get :index
      end

      it { is_expected.to respond_with(200) }
      it { expect(response.body).to have_json_path('data/0/type') }
      it { expect(response.body).to have_json_path('data/0/id') }
      it { expect(response.body).to have_json_path('data/0/name') }
      it { expect(response.body).to have_json_path('data/0/links/self') }

      it { expect(response.body).to_not have_json_path('data/1') }
    end
  end

end
