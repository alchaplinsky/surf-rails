FactoryBot.define do
  factory :tag do
    association :user
    association :submissions
    name {'article'}
  end
end
