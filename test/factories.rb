FactoryBot.define do
  factory :user_f, :class => "User" do
    email { "user_f@test.com" }
    username { "user_f" }
    password { "password"} 
    password_confirmation { "password" }
    #confirmed_at { Date.today }
  end

  factory :meme, :class => "Meme" do
    lang { "de" }
    image { Rack::Test::UploadedFile.new('test/fixtures/files/first.jpg', 'image/jpg') }
    association :user, factory: :user_f
  end
end