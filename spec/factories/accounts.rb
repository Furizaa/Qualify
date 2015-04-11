require 'faker'

FactoryGirl.define do
  factory :account do |a|
    a.id { Faker::Number }
    a.email { Faker::Internet.email }
  end

  factory :account_with_api_access, class: Account do |a|
    a.id { Faker::Number }
    a.email { Faker::Internet.email }

    transient do
      api_key_count 5
    end

    after(:create) do |account, evaluator|
      create_list(:api_key, evaluator.api_key_count, account: account)
    end
  end
end
