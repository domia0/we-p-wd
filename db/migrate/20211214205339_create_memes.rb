class CreateMemes < ActiveRecord::Migration[6.1]
  def change
    create_table :memes do |t|
      t.string :lang, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
