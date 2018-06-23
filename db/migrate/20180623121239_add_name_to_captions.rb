class AddNameToCaptions < ActiveRecord::Migration[5.2]
  def change
    add_column :captions, :name, :string
  end
end
