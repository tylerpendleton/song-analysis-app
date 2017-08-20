class ChangeSongSectionTypeName < ActiveRecord::Migration[5.0]
  def change
    rename_column :song_sections, :type, :sectioon
  end
end
