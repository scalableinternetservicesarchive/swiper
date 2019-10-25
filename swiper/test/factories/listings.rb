FactoryBot.define do
  factory :listing do
    # name { Faker::Hipster.sentence }
    # description { Faker::Hipster.paragraph }
    price {4.0 + Faker::Number.within(range: 0..6)*0.25}
    location {Faker::Number.within(range: 0..7)}
    amount {Faker::Number.within(range: 1..5)}
    description {Faker::Hipster.paragraph(sentence_count: 2)}
    start_time {Faker::Time.between(from: DateTime.now - 1000, to: DateTime.now)}
    end_time{Faker::Time.between(from: DateTime.now, to: DateTime.now+1000)}
    association(:user)
  end
end
