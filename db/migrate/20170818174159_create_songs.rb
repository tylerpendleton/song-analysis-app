class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.float :duration_ms
      t.integer :key
      t.integer :tempo
      t.integer :time_signature, :integer
      t.boolean :explicit
      t.string :copyright_text
      t.string :copyright_type
      t.string :label, array:true, default: []
      t.string :uri, :string
      t.integer :spotify_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
