FactoryBot.define do
  factory :moderator, :class => "User" do
    email { "moderator@test.com" }
    username { "moderator" }
    role {"moderator"}
    password { "password"} 
    password_confirmation { "password" }
    #confirmed_at { Date.today }
  end

  factory :admin, :class => "User" do
    email { "admin@test.com" }
    username { "admin" }
    role {"admin"}
    password { "password"} 
    password_confirmation { "password" }
    #confirmed_at { Date.today }
  end


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

  factory :meme2, :class => "Meme" do
    lang { "de" }
    image { Rack::Test::UploadedFile.new('test/fixtures/files/second.jpg', 'image/jpg') }
    association :user, factory: :user_f
  end

  factory :user_not_owner, :class => "User" do
    email { "notowner@test.com" }
    username { "notowner" }
    password { "password"} 
    password_confirmation { "password" }
    #confirmed_at { Date.today }
  end



  #factory :tag, :class => "Tag" do
   # name { "tag1" }
    #meme
  #end

  #def meme_with_tas(tags_count: 2)
   # FactoryBot.create(:meme) do |profile|
    #  FactoryBot.create_list(:tag, tags_count, memes: [meme])
    #end
  #send

end