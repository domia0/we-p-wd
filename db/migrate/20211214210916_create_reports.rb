class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      # Polymorphic Association
      t.integer :reportable_id,   null: false
      t.string  :reportable_type, null: false

      t.references :user, null: false, foreign_key: true

      t.integer :reason, null: false
      t.boolean :open, null: false, default: true

      t.timestamps
    end
  end
end
