FactoryGirl.define do
  factory :schema do
    name { Faker::Name.name }
    uuid { SecureRandom.uuid }
    account
  end

end
