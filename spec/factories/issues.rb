FactoryBot.define do
  factory :issue do
    title { Faker::Lorem.word }
    created_by { Faker::Number.number(10) }
    assigned_to { Faker::Number.number(10) }
    status "pending"
  end
end
