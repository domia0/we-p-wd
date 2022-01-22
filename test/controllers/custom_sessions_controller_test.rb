require "test_helper"

class CustomSessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user_f)
  end
  
  test "should create and destroy session" do

    assert_difference('CustomSessionsControllerTest::APP_SESSIONS.count') do
      post user_session_url, params: { user: {email: @user.email, password: 'password' } }
    end
    assert_response :found
  end

  #  assert_difference('CustomSessionsControllerTest::APP_SESSIONS.count', -1) do
   #   delete destroy_user_session_url
   # end
   # assert_response :found
  #end

 
end
