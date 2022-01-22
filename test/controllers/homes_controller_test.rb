require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user_f)
  end

  test "should get index - user" do
    sign_in @user
    get root_url
    assert_response :success
  end

  test "should get index - not signed in" do
    get root_url
    assert_response :success
  end

  test "should get index - tag" do
    get root_url(tag: "MyTag1")
    #Ich habe 2 memes mit tag1. Beide memes haben jeweils 2 tags, also erwarte ich hier 4 span-tags für meine 4 meme tags
    assert_select ".tags" do
      assert_select "span", 4
    end
    assert_response :success
    
    get root_url(tag: "MyTag2")
    #Ich habe 1 meme mit tag2. Das meme hat insgesamt 2 tags, also erwarte ich hier 2 span-tags für meine 2 meme tags
    assert_select ".tags" do
      assert_select "span", 2
    end
  end

  test "should get index - filter=best_all_time" do
    get root_url(filter: "best_all_time")
    
    assert_response :success
  end

  test "should NOT get index - tag=nix" do
    #Hier erwarte ich einen Fehler, da ich Tag.find_by(name: params[:tag]).memes im HomesController aufrufe
    assert_raises(NoMethodError) do
      get root_url(tag: "nix")
    end
  end

  test "should get EMPTY index - filter=nix" do
    get root_url(filter: "nix")
    #Diesen filter gibt es nicht also erwarte ich keine span-tags, da keine memes geladen werden
    #Ich erwarte aber auch keinen Fehler, da ich keine Methode von einer NilClass aufrufe
    assert_select ".tags", 0
    assert_response :success
  end
end
