require "test_helper"

class MemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::ControllerHelpers

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
    sign_in users(:user1)
    assert_difference('Meme.count') do
      post memes_url, params: { meme: {lang: 'de', image: fixture_file_upload("first.jpg", "image/jpg") } }
    end
    assert_edirect_to root_path
    #assert_equal 'Article was successfully created.', flash[:notice]
  end

  #test "should destroy meme" do
    #sign_in @user1
   # assert_difference('Meme.count', -1) do
    #  delete meme_url(@meme)
    #end
 # end

end
