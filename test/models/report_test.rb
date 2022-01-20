require "test_helper"

class ReportTest < ActiveSupport::TestCase
  def setup
    @r1 = reports(:report1) #belongs_to reportable (Meme) meme1 and user1
    @r2 = reports(:report2) #belongs_to reportable (Meme) meme1 and user2
    @r3 = reports(:report3) #belongs_to reportable (Comment) comment1 and user1
    @r4 = reports(:report4) #belongs_to reportable (Comment) comment1 and user2
  end

   test "belongs_to user" do
    assert @r1
    assert @r1.user
    assert @r2.user
    assert_equal "test1", @r1.user.username
    assert_not_equal "test1", @r2.user.username
    assert_equal "test2", @r2.user.username
    assert_not_equal "test2", @r1.user.username

    #A report have to belong to a user
    @r1.user = nil
    assert_not @r1.valid?
   end

   test "belongs_to likeable" do
    assert @r1.reportable
    assert @r2.reportable
    assert @r3.reportable
    assert @r4.reportable

    assert_instance_of Meme, @r1.reportable
    assert_not_instance_of Comment, @r1.reportable
    assert_instance_of Comment, @r3.reportable
    assert_not_instance_of Meme, @r3.reportable

    #report2 was created by user2
    assert_equal "test2", @r2.user.username
    #report2 was created by user2 but the reported meme1 was created of user1
    assert_equal "test1", @r2.reportable.user.username
    #report4 was created by user2
    assert_equal "test2", @r4.user.username
    #report4 was created by user2 but the reported comment1 was created of user1
    assert_equal "test1", @r4.reportable.user.username

    #check related meme and comment
    assert_equal "de", @r1.reportable.lang
    assert_equal "de", @r2.reportable.lang
    assert_equal "MyText1", @r3.reportable.body
    assert_equal "MyText1", @r4.reportable.body

    #A Like needs to belong_to a Meme or a Comment
    @r1.reportable = nil
    assert_not @r1.valid?
  end

  test "enum reason" do
    assert @r1.reason
    assert_equal "racism", @r1.reason
    assert_not_equal "religion", @r1.reason

    #Schade, hier kommt ein Error:
    #@r1.reason = "car"
    #assert_not @r1.valid?
    #Error:
    #ReportTest#test_enum_reason:
    #ArgumentError: 'car' is not a valid reason
    #test/models/report_test.rb:60:in `block in <class:ReportTest>'
    #-> genau diesen Error will ich ja provozieren, 
    #jedoch komme ich nicht bis zu @r1.valid? weil er schon direkt bei der falschen Zuweisung meckert
    #dieser Error zegt jedoch, dass das Model sich wie zu erwarten verhält
  
  end
end
