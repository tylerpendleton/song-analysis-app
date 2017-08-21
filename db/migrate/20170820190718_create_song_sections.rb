class CreateSongSections < ActiveRecord::Migration[5.0]
  def change
    create_table :song_sections do |t|
      t.string :section
      t.text :lyrics
      t.string :instrumentation, array: true, default: []
      t.integer :song_structure_id

      t.timestamps
    end
  end
end
