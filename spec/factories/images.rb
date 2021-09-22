FactoryBot.define do
  factory :image do
    association :submission
    title {'Nice photo'}
    domain {'500px.com'}
    url {'http://500px.com/photo/123'}
  end
end
