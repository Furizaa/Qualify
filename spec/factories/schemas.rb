FactoryGirl.define do
  factory :schema do
    name { Faker::Name.name }
    uuid { SecureRandom.hex(16) }
    account
  end

end
