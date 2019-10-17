FactoryBot.define do
  factory :listing do
    name { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph }
    association(:user)
  end
end
