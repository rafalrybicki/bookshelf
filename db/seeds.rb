user = User.create!(email: 'user@example.com', password: 'password')

10.times { |n| Category.create!(name: Faker::Book.genre + n.to_s, owner: user) }

25.times do
  Book.create!(title: Faker::Book.title,
               author: Faker::Book.author,
               categories: [rand(1..10)],
               status: rand(0..3),
               owner: user)
  Book.create!(title: Faker::Book.title,
               author: Faker::Book.author,
               categories: [1, 6],
               status: rand(0..3),
               owner: user)
  Book.create!(title: Faker::Book.title,
               author: Faker::Book.author,
               categories: [3, 5],
               status: rand(0..3),
               owner: user)
  Book.create!(title: Faker::Book.title,
               author: Faker::Book.author,
               categories: [2, 4, 7, 10],
               status: rand(0..3),
               owner: user)
end
