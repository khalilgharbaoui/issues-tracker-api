User.create!([
  # Authorization:'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjIxNjQ3ODQ5MTd9.cGZHBZ6JdyjPGVIH7dBsQIr3BQAu7tlbZ_f4f5ggFGI'
  # password: password1
  {name: "User1", email: "user1@gmail.com", password_digest: "$2a$10$Ws3bThS9HcdM4zm2MiPAO.yuXoagaxB/jOKxykzsIqt9P7VAYlUfq", manager: false},
  # Authorization:'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjIxNjQ3ODUyMzV9.a02R0yCL4I01NqDSRBomRJl_w-OReEr9SkXOYuboGKo'
  # password: password1
  {name: "Manager1", email: "manager1@gmail.com", password_digest: "$2a$10$0gVFq7jo92/VIYMusuAUbeWztzY7rzZpA3BDswlIH4lksmSuxoY..", manager: true}
])

30.times.each_with_index do  |i|
  issue = Issue.create(title: "ISSUE ##{i} "+Faker::Lorem.word, user_id: i.even? ? User.first.id : User.second.id)
  sleep 0.23
end
