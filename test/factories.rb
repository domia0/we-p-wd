FactoryBot.define do
  factory :user do
    email { "user_f@test.com" }
    username { "user_f" }
    password { "password"} 
    password_confirmation { "password" }
    #confirmed_at { Date.today }
  end
end