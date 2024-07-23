FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}remember.com" }
    sequence(:name) { |n| "User #{n}"}
  end
end
