require 'rails_helper'

RSpec.describe Schema, type: :model do
  it_behaves_like 'has_uuid'
  it { is_expected.to validate_presence_of(:name) }
end
