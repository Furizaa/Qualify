require 'rails_helper'
require 'pbkdf2'

RSpec.describe Pbkdf2, 'hash_password' do

  let(:hash) { Pbkdf2::hash_password('1', '', 1) }

  it 'hashes a string correctly' do
    expect(hash.length).to eq(64)
  end

  it 'makes use of multible iterations' do
    expect(Pbkdf2::hash_password('1', '', 2)).not_to eq(hash)
  end

  it 'makes use of a provided salt' do
    expect(Pbkdf2::hash_password('1', '1', 1)).not_to eq(hash)
  end
end