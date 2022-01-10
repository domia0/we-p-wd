class MemesCleanupJob < ApplicationJob
  queue_as :default

  #Sollte man anstatt alle tags zu prüfen, lieber direkt nachdem erstellen eines memes den miterstellten tag prüfen?
  def perform(*args)
    #Give me all tags in an array
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
  end

  def offensive_words
    return off_words = ["shit","fuck", "test"]
  end

end
