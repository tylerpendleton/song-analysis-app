class AlterSongsAddArtistAlbumCopyright < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :copyright_text, :string
    add_column :songs, :copyright_type, :string
    add_column :songs, :label, :string, array:true, default: []
    add_column :songs, :artist_id, :integer
  end
end
