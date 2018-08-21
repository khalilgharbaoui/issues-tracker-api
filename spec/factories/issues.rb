FactoryBot.define do
  factory :issue do
    title { Faker::Lorem.word }
    user_id { Faker::Number.number(10) }
    assigned_to nil
    status "pending"
  end
end
