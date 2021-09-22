FactoryBot.define do
  factory :user do
    first_name {'Jack'}
    last_name {'Daniels'}
    sequence :email do |i|
      "jack.daniels#{i}@gmail.com"
    end
    api_token { SecureRandom.hex(8) }
    provider {'facebook'}
    password {'PASSWORD'}
    uid {12345678}
    premium {false}

    trait :with_avatar do
      avatar {File.open(File.join(Rails.root, 'spec', 'assets', 'avatar.png'))}
    end
  end
end
