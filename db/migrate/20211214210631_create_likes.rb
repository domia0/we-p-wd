class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      # Polymorphic Association
      t.integer :likeable_id,   null: false
      t.string  :likeable_type, null: false

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
