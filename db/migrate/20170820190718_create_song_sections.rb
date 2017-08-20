class CreateSongSections < ActiveRecord::Migration[5.0]
  def change
    create_table :song_sections do |t|
      t.string :type
      t.text :lyrics
      t.string :instrumentation, array: true, default: []

      t.timestamps
    end
  end
end
