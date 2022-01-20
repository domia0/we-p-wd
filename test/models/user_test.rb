require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @u1 = users(:user1)
    @u2 = users(:user2)
    @mo1 = users(:moderator1)
    @a1 = users(:admin1)
  end

  test "role" do
    assert @u1
    assert @mo1
    assert @a1
    assert @u1.role
    assert @mo1.role
    assert @a1.role
    assert_equal "user", @u1.role
    assert_equal "moderator", @mo1.role
    assert_equal "admin", @a1.role
  end

  test "has_many memes" do
    assert @u1.memes
    assert_equal 2, @u1.memes.size
  end

  test "has_many comments" do
    assert @u1.comments
    assert_equal 2, @u1.comments.size
  end

  test "has_many likes" do
    assert @u1.likes
    assert_equal 2, @u1.likes.size
  end

  test "has_many reports" do
    assert @u1.reports
    assert_equal 2, @u1.reports.size
  end

  test "validation username - presence and uniqueness" do
    assert @u1.username
    @u1.username = @u2.username
    assert_not @u1.valid?
    @u1.username = nil
    assert_not @u1.valid?
    @u1.username = "neuertestname"
    assert @u1.valid?
  end
end
