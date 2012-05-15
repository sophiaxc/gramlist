namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_gramposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_gramposts
  users = User.all(limit: 3)
  15.times do
    title = Faker::Lorem.sentence(3)
    description = Faker::Lorem.sentence(7)
    photo_index = (1..5).to_a.sample
    photo = File.open("./app/assets/images/sample_data/sample_photo_#{photo_index}.jpeg")
    price = (1..10).to_a.sample * 100
    users.each { |user| user.gramposts.create!(title: title,
                                               description: description,
                                               photo: photo,
                                               price: price) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
