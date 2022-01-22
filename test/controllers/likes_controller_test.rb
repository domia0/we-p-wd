require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @meme = FactoryBot.create(:meme)
    @user = @meme.user
    @user_not_owner = FactoryBot.create(:user_not_owner)
    @image = fixture_file_upload("first.jpg", "image/jpg")
  end

  test "should create like" do
    sign_in @user
    assert_difference('Like.count') do
      post meme_likes_url(meme_id: @meme.id)
    end
    assert_response :found
  end

  test "should NOT create second like - 2 times" do
    sign_in @user
    assert_difference('Like.count') do
      post meme_likes_url(meme_id: @meme.id)
    end
    assert_response :found

    assert_difference('Like.count', 0) do
      post meme_likes_url(meme_id: @meme.id)
    end
    assert_response :found
  end

  test "should NOT create like - blocked" do
    @user.blocked = true
    sign_in @user
    assert_difference('Like.count', 0) do
      post meme_likes_url(meme_id: @meme.id)
    end
    assert_response :found
  end

  test "should destroy like" do
    sign_in @user
    post meme_likes_url(meme_id: @meme.id)
    assert_difference('Like.count', -1) do
      delete meme_like_url(meme_id: @meme.id, id: Like.last.id )
    end
    assert_response :no_content
  end


end
