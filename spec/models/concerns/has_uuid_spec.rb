require 'rails_helper'

RSpec.shared_examples_for 'has_uuid' do
  let(:model) { described_class } # the class that includes the concern

  it 'generates a uuid' do
    unique_identifyable = FactoryGirl.create(model.to_s.underscore.to_sym)
    expect(unique_identifyable.uuid.length).to eq(32)
  end
end
