FactoryBot.define do
  factory :interest_membership do
    association :user
    association :interest
    role {'member'}
  end
end
