FactoryBot.define do
  factory :days do
    date { Date.new(2024, 6, 6) }
    user
    month
  end
end
