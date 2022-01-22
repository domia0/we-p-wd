require "test_helper"

class MemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
=begin
  test "Meme count" do
    assert_equal 3, Meme.all.count
    assert_equal 4, Comment.all.count
    assert_equal 4, Like.all.count
    assert_equal 4, Report.all.count
    assert_equal 3, Tag.all.count
    assert_equal 4, User.all.count
  end 
=end 

#=begin
  setup do
    @meme = FactoryBot.create(:meme)
    @user = @meme.user
    @user_not_owner = FactoryBot.create(:user_not_owner)
    @image = fixture_file_upload("second.jpg", "image/jpg")
    @admin = FactoryBot.create(:moderator)
    @moderator = FactoryBot.create(:admin)
  end

  test "should get index - admin" do
    sign_in @admin
    get memes_url
    assert_equal 3, Meme.all.count
    assert Meme.last.image
    assert_equal "de", Meme.first.lang
    assert_response :success
  end
  

  test "should get index - moderator" do
    sign_in @moderator
    assert get memes_url
    assert_response :success
  end

  test "should NOT get index - user" do
    sign_in @user
    assert get memes_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should get show - admin" do
    sign_in @admin
    get meme_url(id: @meme.id)
    assert_response :success
  end

  test "should get show - moderator" do
    sign_in @moderator
    get meme_url(id: @meme.id)
    assert_response :success
  end

  test "should NOT get show - user" do
    sign_in @user
    get meme_url(id: @meme.id)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should create meme" do
    sign_in @user
    assert_difference('Meme.count') do
      post memes_url, params: { meme: {lang: 'en', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_redirected_to root_path
  end

  test "should NOT create meme - not signed in" do
    assert_difference('Meme.count', 0) do
      post memes_url, params: { meme: {lang: 'en', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_response :redirect
  end

  test "should NOT create meme - user blocked" do
    @user.blocked = true
    sign_in @user
    assert_difference('Meme.count', 0) do
      post memes_url, params: { meme: {lang: 'en', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_response :redirect
  end

  test "should destroy meme" do
    sign_in @user
    assert_difference('Meme.count', -1) do
      delete meme_url(id: @meme.id)
    end
    assert_response :redirect
  end

  test "should NOT destroy meme - not owner" do
    @user_not_owner
    sign_in @user_not_owner
    assert_difference('Meme.count', 0) do
      delete meme_url(id: @meme.id)
    end
    assert_response :no_content
  end

  test "should destroy meme - moderator" do
    sign_in @moderator
    assert_difference('Meme.count', -1) do
      delete meme_url(id: @meme.id)
    end
    assert_response :redirect
  end

  test "should destroy meme - admin" do
    sign_in @admin
    assert_difference('Meme.count', -1) do
      delete meme_url(id: @meme.id)
    end
    assert_response :redirect
  end
end
