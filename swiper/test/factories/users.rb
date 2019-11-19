FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example_user_#{n}@example.com" }
    password { "password" }
    cash {Faker::Boolean.boolean}
    venmo {Faker::Boolean.boolean}
    paypal {Faker::Boolean.boolean}
    cashapp {Faker::Boolean.boolean}
    contact {Faker::PhoneNumber.phone_number}
  end
end
