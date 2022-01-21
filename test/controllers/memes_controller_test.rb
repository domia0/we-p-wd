require "test_helper"

class MemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    #@user = FactoryBot.create(:user_f)
    @meme = FactoryBot.create(:meme)
    @user = @meme.user
   # @image = attachments(:meme1_image_attachment)
   # @user_ = users(:user1)
  end

  test "should get index - moderator" do
    @user.role = 1
    sign_in @user
    get memes_url
    assert_response :success
    assert_not_nil assigns(:meme)
  end

  test "should NOT get index - user" do
    sign_in @user
    get memes_url
    assert_response :found
    assert_nil assigns(:meme)
  end

  test "should get show - moderator" do
    @user.role = 1
    sign_in @user
    get memes_url
    assert_response :success
    assert_not_nil assigns(:meme)
  end

  test "should NOT get show - user" do
    sign_in @user
    get memes_url
    assert_response :found
    assert_nil assigns(:meme)
  end

  test "should create meme" do
    sign_in @user
    assert_difference('Meme.count') do
      post memes_url, params: { meme: {lang: 'de', image: fixture_file_upload("first.jpg", "image/jpg") }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_redirected_to root_path
  end

  test "should NOT create meme - not signed in" do
    assert_difference('Meme.count', 0) do
      post memes_url, params: { meme: {lang: 'de', image: fixture_file_upload("first.jpg", "image/jpg") }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_response :found
  end

  test "should NOT create meme - user blocked" do
    @user.blocked = true
    sign_in @user
    assert_difference('Meme.count', 0) do
      post memes_url, params: { meme: {lang: 'de', image: fixture_file_upload("first.jpg", "image/jpg") }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_response :found
  end

  test "should destroy meme" do
    sign_in @user
    assert_difference('Meme.count', -1) do
      delete meme_url(id: @meme.id)
    end
  end

end
