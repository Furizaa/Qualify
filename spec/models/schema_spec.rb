require 'rails_helper'
require_relative 'concerns/has_uuid_spec'

RSpec.describe Schema, type: :model do
  it_behaves_like 'has_uuid'
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name) }
end
