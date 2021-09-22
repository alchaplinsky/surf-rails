FactoryBot.define do
  factory :interest do
    name {'Travel'}

    after(:create) do |interest, evaluator|
      create :interest_membership, user: evaluator.user, interest: interest, role: 'owner'
    end
  end
end
