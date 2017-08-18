class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.float :length
      t.integer :key
      t.integer :tempo

      t.timestamps
    end
  end
end
