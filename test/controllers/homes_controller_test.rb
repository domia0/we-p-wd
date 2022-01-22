require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @meme = FactoryBot.create(:meme)
    @user = @meme.user
    @image = fixture_file_upload("first.jpg", "image/jpg")
  end

  test "should get index" do
    sign_in @user
    post memes_url, params: { meme: {lang: 'de', image: @image }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    get root_url
    #assert_response :found
    #assert_not_nil assigns(:meme)
  end

end
