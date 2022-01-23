class MemesCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)

    all_tags = Tag.all.to_a
    all_tags.each do |tag_element|  
      if offensive_words.include?(tag_element[:name])
        memes = Tag.find_by(name: tag_element[:name]).memes
        memes.each do |meme_element|
          meme = Meme.find(meme_element[:id])
          meme.destroy
        end
      end
    end

    all_comments = Comment.all.to_a
    all_comments.each do |comment_element|
      offensive_words.each do |word|
        if comment_element[:body].match(/#{word}/)
          comment = Comment.find(comment_element[:id])
          comment.destroy
        end
      end
    end
  end

  def offensive_words
    return off_words = ["shit","fuck"]
  end

end
