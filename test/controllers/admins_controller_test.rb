require "test_helper"

class AdminsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = FactoryBot.create(:user_f)
    @admin = FactoryBot.create(:admin)
    @moderator = FactoryBot.create(:moderator)
  end

  test "should get index - admin" do
    sign_in @admin
    get "/admins"
    assert_response :success
  end


  test "should NOT get index - moderator" do
    sign_in @moderator
    get "/admins"
    assert_response :redirect
  end

  test "should NOT get index - user" do
    sign_in @user
    get "/admins"
    assert_response :redirect
    assert_redirected_to root_path
  end
end