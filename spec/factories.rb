FactoryBot.define do
  factory :category do
    name { Faker::Book.genre }
    association :owner, factory: :user
  end

  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
  end
end
