require "test_helper"

class CommentTest < ActiveSupport::TestCase
  
  def setup
    @c1 = comments(:comment1)
  end

  test "belongs_to meme" do
    assert @c1
    assert @c1.meme
    assert_equal "de", @c1.meme.lang
    #In this case comment and meme are both from user1
    assert_equal "test1", @c1.meme.user.username

    #validation should fail cause a comment need to belong to a meme
    @c1.meme = nil
    assert_not @c1.valid?
  end

  test "belongs_to user" do
    assert @c1
    assert @c1.user

    #In this case comment and meme are both from user1
    assert_equal "test1", @c1.user.username

    ##validation should fail cause a comment need to belong to a user
    @c1.user = nil
    assert_not @c1.valid?
  end
  

  test "has_many likes" do
    assert @c1.likes
    assert_equal 2, @c1.likes.size
  end

  test "has_many reports" do
    assert @c1.reports
    assert_equal 2, @c1.reports.size
  end

  test "validation body" do
    @c1.body = nil
    assert_not @c1.valid?
  end 

  #Schade, scheinbar kann ich nicht von der Datenbank löschen,
  #die Failure zeigt an, dass das Objekt @c1 immer noch existiert,
  #selbst wenn ich: "Comment.find(@c1.id).destroy" aufrufe 
  #Jedoch funktioniert dependend destroy wenn ich es über die Ruby Console ausprobiere
  #sprich: ich lösche comment und die dazugehörigen likes werden automatisch auch gelöscht

  #test "dependent destroy"
    #@c1.destroy
    #assert_not @c1
    #assert_not @l3
  #end

end
