FactoryBot.define do
  factory :submission do
    association :user
    association :interest
    text {'This is cool snippet'}
  end
end
