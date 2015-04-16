require 'rails_helper'
require 'guardian'

RSpec.describe 'Guardian' do

  context 'Schema' do

    let(:schema) { FactoryGirl.create(:schema) }
    let(:account) { schema.account }

    describe '#can_view_schema' do
      it 'returns false if parameter is nil' do
        expect(Guardian.new(account).can_view_schema?(nil)).to be_falsey
      end

      it 'returns true if the account is owner of the schema' do
        expect(Guardian.new(account).can_view_schema?(schema)).to be_truthy
      end

      it 'returns false if the account is not the owner' do
        guard = Guardian.new(account)
        schema.account = FactoryGirl.create(:account)
        expect(guard.can_view_schema?(schema)).to be_falsey
      end
    end
  end
end
