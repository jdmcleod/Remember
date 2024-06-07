FactoryBot.define do
  factory :month do
    quarter
    sequence(:name) { |n| "Month #{n}" }
  end
end
