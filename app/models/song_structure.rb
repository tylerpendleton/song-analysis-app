class SongStructure < ApplicationRecord

  belongs_to :song
  has_many :song_sections
end
