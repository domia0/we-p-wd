require "test_helper"

class MemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @meme = FactoryBot.create(:meme)
    @user = @meme.user
    @user_not_owner = FactoryBot.create(:user_not_owner)
    @image = fixture_file_upload("first.jpg", "image/jpg")
    @admin = FactoryBot.create(:moderator)
    @moderator = FactoryBot.create(:admin)
  end

  test "should get index - admin" do
    sign_in @admin
    post memes_url, params: { meme: {lang: 'de', image: fixture_file_upload("first.jpg", "image/jpg") }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    get memes_url
    assert_response :found
    assert_redirected_to root_path
    #assert_not_nil assigns(:meme)
  end
  

  test "should get index - moderator" do
    sign_in @moderator
    post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    assert get memes_url
    assert_response :success
    assert_redirected_to root_path
    #assert_not_nil assigns(:meme)
  end

  test "should NOT get index - user" do
    sign_in @user
    get memes_url
    post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    assert_response :redirect
    assert_redirected_to root_path
   # assert_nil assigns(:meme)
  end

  test "should get show - admin" do
    sign_in @admin
    post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    get memes_url
    assert_response :found
    #assert_not_nil assigns(:meme)
  end

  test "should get show - moderator" do
    sign_in @moderator
    post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    get memes_url
    assert_response :found
    #assert_not_nil assigns(:meme)
  end

  test "should NOT get show - user" do
    sign_in @user
    post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    get memes_url
    assert_response :found
    assert_redirected_to root_path
    #assert_nil assigns(:meme)
  end

  test "should create meme" do
    sign_in @user
    assert_difference('Meme.count') do
      post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_redirected_to root_path
  end

  test "should NOT create meme - not signed in" do
    assert_difference('Meme.count', 0) do
      post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_response :found
  end

  test "should NOT create meme - user blocked" do
    @user.blocked = true
    sign_in @user
    assert_difference('Meme.count', 0) do
      post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_response :found
  end

  test "should destroy meme" do
    sign_in @user
    assert_difference('Meme.count', -1) do
      delete meme_url(id: @meme.id)
    end
    assert_response :found
  end

  test "should NOT destroy meme - not owner" do
    @user_not_owner
    sign_in @user_not_owner
    assert_difference('Meme.count', 0) do
      delete meme_url(id: @meme.id)
    end
    assert_response :no_content
  end

  test "should destroy meme - modertor" do
    @user_not_owner.role = 1
    sign_in @user_not_owner
    assert_difference('Meme.count', -1) do
      delete meme_url(id: @meme.id)
    end
    assert_response :found
  end

  test "should destroy meme - admin" do
    @user_not_owner.role = 2
    sign_in @user_not_owner
    assert_difference('Meme.count', -1) do
      delete meme_url(id: @meme.id)
    end
    assert_response :found
  end
end
