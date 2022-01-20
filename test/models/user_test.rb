require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @u1 = users(:user1)
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

end
