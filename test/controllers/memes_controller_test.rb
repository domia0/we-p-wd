require "test_helper"

class MemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @meme = memes(:meme1)
    
   # @image = attachments(:meme1_image_attachment)
   # @user_ = users(:user1)
  end

 # test "should get index" do
  #  get :index
   # assert_response :success
   # assert_not_nil assigns(:meme)
 # end

  test "should create meme" do
    sign_in FactoryBot.create(:user)
    assert_difference('Meme.count') do
      post memes_url, params: { meme: {lang: 'de', image: fixture_file_upload("first.jpg", "image/jpg") }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_redirected_to root_path
  end

  test "should not create meme" do
    assert_difference('Meme.count', 0) do
      post memes_url, params: { meme: {lang: 'de', image: fixture_file_upload("first.jpg", "image/jpg") }, tag: { "1": {name: "tag1"}, "2": {name: "tag2"}, "3": {name: "tag3"} } }
    end
    assert_response :found
  end

  #test "should destroy meme" do
    #sign_in @user1
   # assert_difference('Meme.count', -1) do
    #  delete meme_url(@meme)
    #end
 # end

end
