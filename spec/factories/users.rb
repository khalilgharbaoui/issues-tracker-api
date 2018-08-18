FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email "foo#{Random.rand(1..999)}#{Random.rand(1...999)}@bar.com"
    password 'foobar'
    manager false
  end
end
