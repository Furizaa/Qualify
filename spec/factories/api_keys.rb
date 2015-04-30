FactoryGirl.define do
  factory :api_key do
    account
    key { SecureRandom.uuid }
  end
end
