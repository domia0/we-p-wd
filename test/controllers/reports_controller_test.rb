require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @meme = FactoryBot.create(:meme)
    @user = @meme.user
    @image = fixture_file_upload("first.jpg", "image/jpg")
  end

  test "should create report" do
    sign_in @user
    assert_difference('Report.count') do
      post meme_reports_url(meme_id: @meme.id), params: { report: {reason: 'religion' } }
    end
    assert_response :no_content
    post meme_comments_url(meme_id: @meme.id), params: { comment: {body: 'Hello Rails' } }
    assert_response :no_content
    assert_equal "Hello Rails", @meme.comments.first.body
    assert_difference('Report.count') do
      post meme_comment_reports_url(meme_id: @meme.id, comment_id: @meme.comments.first.id), params: { report: {reason: 'religion' } }
    end
    assert_response :no_content
  end

  test "should NOT create report - not signed in" do
    assert_difference('Report.count', 0) do
      post meme_reports_url(meme_id: @meme.id), params: { report: {reason: 'religion' } }
    end
    assert_response :found
    #login user, post comment, logout, reprt comment
    sign_in @user
    post meme_comments_url(meme_id: @meme.id), params: { comment: {body: 'Hello Rails' } }
    assert_response :no_content
    assert_equal "Hello Rails", @meme.comments.first.body
    sign_out @user
    assert_difference('Report.count', 0) do
      post meme_comment_reports_url(meme_id: @meme.id, comment_id: @meme.comments.first.id), params: { report: {reason: 'religion' } }
    end
    assert_response :found
  end

  test "should NOT create report - user blocked" do
    sign_in @user
    post meme_comments_url(meme_id: @meme.id), params: { comment: {body: 'Hello Rails' } }
    assert_response :no_content
    assert_equal "Hello Rails", @meme.comments.first.body
    sign_out @user
    
    @user.blocked = true
    sign_in @user
    assert_difference('Report.count', 0) do
      post meme_reports_url(meme_id: @meme.id), params: { report: {reason: 'religion' } }
    end
    assert_response :found
    sign_out @user

    @user.blocked = true
    sign_in @user
    assert_difference('Report.count', 0) do
      post meme_comment_reports_url(meme_id: @meme.id, comment_id: @meme.comments.first.id), params: { report: {reason: 'religion' } }
    end
    assert_response :found
  end
end
