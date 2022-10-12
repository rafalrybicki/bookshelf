FactoryBot.define do
  factory :category do
    sequence(:name) { |n| Faker::Book.genre + n.to_s }
    association :owner, factory: :user
  end

  factory :user do
    email { Faker::Internet.email }
    password { 'password' }

    factory :test_user do
      email { 'testuser@example.com' }
    end
  end
end
