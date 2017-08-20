class AlterSongsToAddSpotify < ActiveRecord::Migration[5.0]
  def change
    rename_column :songs, :length, :duration_ms
    add_column :songs, :spotify_id, :integer
    add_column :songs, :explicit, :boolean
    add_column :songs, :uri, :string
    add_column :songs, :time_signature, :integer
  end
end
