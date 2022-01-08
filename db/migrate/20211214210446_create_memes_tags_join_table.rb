class CreateMemesTagsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :memes, :tags do |t|
      t.index [:meme_id, :tag_id], unique: true
      
      t.timestamps
    end
  end
end