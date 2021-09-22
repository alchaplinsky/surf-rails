FactoryBot.define do
  factory :attachment do
    association :submission
    title {'1.pdf'}
    format {'pdf'}
    url {'http://example.com/1.pdf'}
    domain {'example.com'}
  end
end
