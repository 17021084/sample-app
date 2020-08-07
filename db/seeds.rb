User.create!(name: "Nhat Quang",
  email: "quangdvn@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "test#{n + 1}@gmail.com"
  password = "123456"
  User.create!(name: name,
  email: email,
  password: password,
  password_confirmation: password,
  activated: true,
  activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
15.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each{|user| user.microposts.create!(content: content)}
end
