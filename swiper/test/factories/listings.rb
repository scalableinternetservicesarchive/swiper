FactoryBot.define do
  factory :listing do
    # name { Faker::Hipster.sentence }
    # description { Faker::Hipster.paragraph }
    price {3.0 + Faker::Number.within(range: 0..9)*0.25}
    location {Faker::Number.within(range: 0..7)}
    amount {Faker::Number.within(range: 1..5)}
    description {Faker::Hipster.paragraph(sentence_count: 2)}
    start_time {Faker::Time.between(from: DateTime.current + 1.hours, to: DateTime.current + 20.hours)}
    end_time {Faker::Time.between(from: start_time, to: start_time + 4.hours)}
    association(:user)
  end
end
