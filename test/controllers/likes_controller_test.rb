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
    assert_difference('Meme.count') do
      post meme_likes_url(meme_id: @meme.id)#, params: { meme_id: @meme.id  }
    end
    assert_redirected_to root_path
  end

end
