FactoryBot.define do
  factory :invite do
    association :user
    email {'alice@example.com'}
    status {'pending'}
  end
end
