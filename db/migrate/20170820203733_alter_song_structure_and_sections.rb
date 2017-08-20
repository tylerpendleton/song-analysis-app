class AlterSongStructureAndSections < ActiveRecord::Migration[5.0]
  def change
    add_column :song_structures, :song_id, :integer
    add_column :song_sections, :song_structure_id, :integer
  end
end
