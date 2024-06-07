FactoryBot.define do
  factory :user do
    email { 'test@remember.com' }
    sequence(:name) { |n| "User #{n}"}
  end
end
