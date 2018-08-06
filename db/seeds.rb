# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
i = 0

30.times do
  i + 1
  issue = Issue.create(title: "ISSUE ##{i} "+Faker::Lorem.word, created_by: User.first.id)
end
