class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :genres, array: true, default: []
      t.string :spotify_id
      t.string :image_large
      t.string :image_medium
      t.string :image_small

      t.timestamps
    end
  end
end
