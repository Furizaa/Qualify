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
          schema.reload
          delete :destroy, { id: schema.uuid }
        end

        it { is_expected.to respond_with(204) }
        it { expect(Schema.all.length).to be(0) }
      end

      context 'when account does not own the schema' do
        let(:schema) { FactoryGirl.create(:schema) }
        before do
          schema.reload
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
          schema.reload
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
          schema.reload
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
  end

end
