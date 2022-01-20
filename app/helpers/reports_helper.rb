module ReportsHelper
  def get_user_by_rep(reportable)
    if reportable.is_a? Meme
      return Meme.find(reportable.id).user
    elsif reportable.is_a? Comment
      return Comment.find(reportable.id).user
    end
  end

  def get_object_by_rep(reportable)
    if reportable.is_a? Meme
      return Meme.find(reportable.id)
    elsif reportable.is_a? Comment
      return Comment.find(reportable.id)
    end
  end
end