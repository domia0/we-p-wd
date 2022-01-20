require "test_helper"

class MemeTest < ActiveSupport::TestCase
  def setup
    @m1 = memes(:meme1)
    @t1 = tags(:tag1)
    @t2 = tags(:tag2)
    @t3 = tags(:tag3)
  end

  test "belongs_to user" do
    assert @m1
    assert @m1.user

    #Name of the meme creator
    assert_equal "test1", @m1.user.username

    ##validation should fail cause a meme need to belong to a user
    @m1.user = nil
    assert_not @m1.valid?
  end

  test "has_many comments" do
    assert @m1.comments
    assert_equal 2, @m1.comments.size
  end

  test "has_many likes" do
    assert @m1.likes
    assert_equal 2, @m1.likes.size
  end

  test "has_many reports" do
    assert @m1.reports
    assert_equal 2, @m1.reports.size
  end

  test "habtm memes" do
    assert @m1
    assert @t1
    assert @t2
    assert @t3
    assert_equal "MyTag1", tags(:tag1).name
    assert_equal "MyTag2", tags(:tag2).name
    assert_not_nil @m1.tags
    assert_includes @m1.tags, @t1
    assert_includes @m1.tags, @t2
    assert_not_includes @m1.tags, @t3

    assert_includes @t1.memes, @m1
    assert_includes @t2.memes, @m1
    assert_not_includes @t3.memes, @m1
  end

  test "validation lang" do
    assert @m1.lang
    @m1.lang = nil
    assert_not @m1.valid?
    @m1.lang = "aa"
    assert_not @m1.valid?
    @m1.lang = "d"
    assert_not @m1.valid?
    @m1.lang = "dee"
    assert_not @m1.valid?
    @m1.lang = "en"
    assert @m1.valid?
  end

  test "has_one_attached image" do
    assert @m1.image
  end
end
