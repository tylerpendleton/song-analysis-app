class Song < ApplicationRecord
  include SongsHelper
  validates :title, presence: true, length: { minimum: 3 }
end
