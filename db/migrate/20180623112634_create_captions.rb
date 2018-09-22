class CreateCaptions < ActiveRecord::Migration[5.2]
  def change
    create_table :captions do |t|
      t.integer :user_id
      t.string :title
      t.string :size
      t.string :supplies
      t.string :price
      t.text :memo

      t.timestamps
    end
  end
end
