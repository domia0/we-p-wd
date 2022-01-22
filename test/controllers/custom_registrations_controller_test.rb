require "test_helper"

class CustomRegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should create & destroy user" do
    assert_difference('User.all.count') do
      post user_registration_url, params: { user: {email: "new_user@test.com", username: "new_user",  password: 'password' } }
    end
    assert_response :redirect

    assert_difference('User.all.count', -1) do
      delete user_registration_url
    end
    assert_response :redirect
  end
end
