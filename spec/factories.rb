FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    zipcode "94114"

    factory :admin do
      admin true
    end
  end

  factory :grampost do
    title "Post Title"
    zipcode "94114"
    category_id 0
    description "Lorem Ipsum"
    sequence(:price)  { |n| n*100 }
    photo File.open('./app/assets/images/sample_data/grampost_test_photo.png')
    user
  end
end
