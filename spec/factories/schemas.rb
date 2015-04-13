FactoryGirl.define do
  factory :schema do
    name { Faker::Name }
    uuid { SecureRandom.hex(16) }
    account
  end

end
