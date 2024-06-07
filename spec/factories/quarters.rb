FactoryBot.define do
  factory :quarter do
    year
    sequence(:name) { |n| "Month #{n}" }
  end
end
