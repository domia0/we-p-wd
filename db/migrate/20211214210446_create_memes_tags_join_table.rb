class CreateMemesTagsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :memes, :tags do |t|
      #t.index [:meme_id, :tag_id]
      #t.index [:tag_id, :meme_id]
      t.index :meme_id
      t.index :tag_id
      
      t.timestamps
    end
  end
end
