require "test_helper"

class MemesControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should create article" do
    assert_difference('Article.count') do
      post :create, article: {title: 'Hi', body: 'This is my first article.'}
    end
    assert_redirected_to article_path(assigns(:article))
    assert_equal 'Article was successfully created.', flash[:notice]
  end

  test "should destroy child" do
    assert_difference('Child.count', -1) do
      delete child_url(@child)
    end
  end

end
