require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  it { is_expected.to validate_presence_of :key }
  it { is_expected.to validate_uniqueness_of :key }

  describe '.generate_key!' do
    let(:api_key) { ApiKey.new }
    before do
      api_key.generate_key!
    end
    it 'generates key' do
      expect(api_key.key.length).to eq(32)
    end
  end
end
