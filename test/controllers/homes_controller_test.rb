require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user_f)
  end

  test "should get index - user" do
    sign_in @user
    get root_url
    assert_response :success
  end

  test "should get index - not signed in" do
    get root_url
    assert_response :success
  end

  test "should get index - tag" do
    get root_url(tag: "MyTag1")
    assert_select ".tags", 1
    assert_response :success
    
    get root_url(tag: "MyTag2")
    assert_select ".tags", 0
  end

  test "should get index - filter=best_all_time" do
    get root_url(filter: "best_all_time")
    
    assert_response :success
  end

  test "should NOT get index - tag=nix" do
    assert_raises(NoMethodError) do
      get root_url(tag: "nix")
    end
  end

  test "should get EMPTY index - filter=nix" do
    assert_raises(NoMethodError) do 
      get root_url(filter: "nix")
    end
  end
end
