require "test_helper"

class CustomRegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user_f)
  end

  test "should create registration" do
    assert_difference('CustomRegistrationsControllerTest::APP_SESSIONS.count') do
      post user_registration_url, params: { user: {email: "new_user@test.com", username: "new_user",  password: 'password' } }
    end
    assert_response :found
  end

 # test "should destroy registration" do
    #sign_in @user
   # delete destroy_user_registration_url(User.find(@user.id))
    #assert_not @user
    #assert_response :found
  #end
end
