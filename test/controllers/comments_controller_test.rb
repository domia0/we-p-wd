require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @meme = FactoryBot.create(:meme)
    @user = @meme.user
    @user_not_owner = FactoryBot.create(:user_not_owner)
    @image = fixture_file_upload("first.jpg", "image/jpg")
  end

  test "should create comment" do
    sign_in @user
    assert_difference('Comment.count') do
      post meme_comments_url(meme_id: @meme.id), params: { comment: {body: 'Hello Rails' } }
    end
    assert_response :no_content
  end

  test "should NOT create comment - not signed in" do
    assert_difference('Comment.count', 0) do
      post meme_comments_url(meme_id: @meme.id), params: { comment: {body: 'Hello Rails' } }
    end
    assert_response :found
  end

  test "should NOT create comment - user blocked" do
    @user.blocked = true
    sign_in @user
    assert_difference('Comment.count', 0) do
      post meme_comments_url(meme_id: @meme.id), params: { comment: {body: 'Hello Rails' } }
    end
    assert_response :found
  end
end
