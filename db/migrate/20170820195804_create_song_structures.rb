class CreateSongStructures < ActiveRecord::Migration[5.0]
  def change
    create_table :song_structures do |t|
      t.integer :song_id

      t.timestamps
    end
  end
end
