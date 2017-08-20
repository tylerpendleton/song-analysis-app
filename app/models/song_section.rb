class SongSection < ApplicationRecord
  SECTIONS = ["Intro", "Verse", "Chorus", "Instrumental", "Bridge/Middle 8", "Instrumental Solo", "Outro"]

  has_many :songs, through: :song_structure
  belongs_to :song_structure
end
