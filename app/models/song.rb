class Song < ApplicationRecord
  include SongsHelper
  validates :title, presence: true, length: { minimum: 3 }

  belongs_to :artist
  has_one :song_structure
  has_many :song_sections, through: :song_structure
end
