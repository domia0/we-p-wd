require "test_helper"

class TagTest < ActiveSupport::TestCase

  def setup
    @m1 = memes(:meme1)
    @t1 = tags(:tag1)
    @t2 = tags(:tag2)
    @t3 = tags(:tag3)
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

    test "length of name" do
      assert @t1.valid?
      @t1.name = "M"
      assert_not @t1.valid?
      @t1.name = "MyStringismuchtolongiswearitsverylongtolongforthisvalidationitshouldthrowanerrorandpassthistest"
      assert_not @t1.valid?
      @t1.name = "MyStringisvalidbutitsclosetobetobiganditcantbebigg"
      assert @t1.valid?
      @t1.name = "MyStringisvalidbutitsclosetobetobiganditcantbebigge"
      assert_not @t1.valid?
    end

    test "uniqueness of name" do
      @t3.name = "MyTag2"
      assert_not @t3.valid?
    end
end
