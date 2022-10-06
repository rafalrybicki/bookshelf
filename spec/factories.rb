FactoryBot.define do
  factory :category do
    sequence(:name) { |n| Faker::Book.genre + n.to_s }
    association :owner, factory: :user
  end

  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
  end
end
