FactoryGirl.define do
  factory :api_key do
    account
    key { SecureRandom.hex(16) }
  end
end
