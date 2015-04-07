require 'faker'

FactoryGirl.define do
  factory :account do |a|
    a.id { Faker::Number }
    a.email { Faker::Internet.email }
  end
end