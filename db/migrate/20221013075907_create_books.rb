class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: true
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.integer :categories, default: [], array: true
      t.integer :status, default: 0
      t.string :info, null: true

      t.timestamps
    end
  end
end
