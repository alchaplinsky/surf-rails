FactoryBot.define do
  factory :upgrade do
    association :user
    order_id { '0VT31415HM907853T' }
    payer_id { 'QASVQK8ZH2AZC' }
    email { 'jack.dainels@example.com' }
    name { 'Jack Daniels' }
    phone {}
    country { 'US' }
    status { 'COMPLETED' }
  end
end
