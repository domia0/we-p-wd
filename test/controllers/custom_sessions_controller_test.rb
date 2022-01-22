require "test_helper"

class CustomSessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user_f)
  end
  
  test "should create and destroy session" do

    post user_session_url, params: { user: {email: @user.email, password: 'password' } }
    #Nur wenn ich erfolgreich eingeloggt werde, bekomme ich einen redirect
    assert_response :redirect

    delete destroy_user_session_url
    assert_response :redirect
  end
end
