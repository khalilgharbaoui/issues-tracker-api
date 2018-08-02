FactoryBot.define do
  factory :issue do
    title "Fake issue nr 1"
    created_by "user_1"
    assigned_to "nobody"
    status "pending"
  end
end
