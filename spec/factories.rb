FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    association :owner, factory: :user
  end

  factory :category do
    sequence(:name) { |n| Faker::Book.genre + n.to_s }
    association :owner, factory: :user
  end

  factory :user do
    email { Faker::Internet.email }
    password { 'password' }

    factory :test_user do
      email { 'test_user@example.com' }
    end
  end
end
