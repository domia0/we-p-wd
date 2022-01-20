require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup
    @m2 = memes(:meme2)
    @l1 = likes(:like1) #belongs_to likeable (Meme) meme1 and user1
    @l2 = likes(:like2) #belongs_to likeable (Meme) meme1 and user2
    @l3 = likes(:like3) #belongs_to likeable (Comment) comment1 and user1
    @l4 = likes(:like4) #belongs_to likeable (Comment) comment1 and user2
  end

   test "belongs_to user" do
     assert @l1
     assert @l1.user
     assert @l2.user
     assert_equal "test1", @l1.user.username
     assert_not_equal "test1", @l2.user.username
     assert_equal "test2", @l2.user.username
     assert_not_equal "test2", @l1.user.username

    #like1 was created by user1 and the liked meme1 was created of user1
    assert_equal "test1", @l1.likeable.user.username

    #A like have to belong to a user
    @l1.user = nil
    assert_not @l1.valid?
   end

   test "belongs_to likeable" do
    assert @l1.likeable
    assert @l2.likeable
    assert @l3.likeable
    assert @l4.likeable

    assert_instance_of Meme, @l1.likeable
    assert_not_instance_of Comment, @l1.likeable
    assert_instance_of Comment, @l3.likeable
    assert_not_instance_of Meme, @l3.likeable

    #like2 was created by user2
    assert_equal "test2", @l2.user.username
    #like2 was created by user2 but the liked meme1 was created of user1
    assert_equal "test1", @l2.likeable.user.username
    #like4 was created by user2
    assert_equal "test2", @l4.user.username
    #like4 was created by user2 but the liked comment1 was created of user1
    assert_equal "test1", @l4.likeable.user.username

    #check related meme and comment
    assert_equal "de", @l1.likeable.lang
    assert_equal "de", @l2.likeable.lang
    assert_equal "MyText1", @l3.likeable.body
    assert_equal "MyText1", @l4.likeable.body

    #A Like have to belong_to a Meme or a Comment
    @l1.likeable = nil
    assert_not @l1.valid?
  end

  test "validation of user_id & likeable uniqueness" do
    #A user1 can like meme1 & meme2
    assert @m2
    assert @l1
    @l2.user = @l1.user
    @l2.likeable = @m2
    assert @l2

    #A user can only like a object 1 time
    @l2.likeable = @l1.likeable
    @l2.user = @l1.user
    assert_not @l2.valid?
  end
end
