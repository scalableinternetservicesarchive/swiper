FactoryBot.define do
  factory :listing do
    # name { Faker::Hipster.sentence }
    # description { Faker::Hipster.paragraph }
    price {4.0 + Faker::Number.within(range: 0..6)*0.25}
    location {Faker::Number.within(range: 0..7)}
    amount {Faker::Number.within(range: 1..5)}
    association(:user)
  end
end
