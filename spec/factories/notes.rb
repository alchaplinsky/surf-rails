FactoryBot.define do
  factory :note do
    association :submission
    title {'Note title'}
    text {'Note text'}
  end
end
