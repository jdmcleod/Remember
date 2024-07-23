FactoryBot.define do
  factory :entry do
    content { nil }
    user
    journalable { create(:day) }

    trait :with_content do
      after :build do |entry, evaluator|
        entry.content.body = evaluator.content
        entry.save
      end
    end
  end
end
