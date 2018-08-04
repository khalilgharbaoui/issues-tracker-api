FactoryBot.define do
  factory :issue do
    title { Faker::Lorem.word }
    created_by { Faker::Number.number(10) }
    assigned_to nil
    status "pending"
  end
end
