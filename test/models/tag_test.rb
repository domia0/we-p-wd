require "test_helper"

class TagTest < ActiveSupport::TestCase
   test "habtm memes" do
     m1 = memes(:meme1)
     t1 = tags(:tag1)
     assert m1
     assert t1
     assert "MyTag1", tags(:tag1).name
     assert_not_nil m1.tags
     assert "MyTag1", m1.tags.first.name
   end
end
