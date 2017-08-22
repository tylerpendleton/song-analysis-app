class SongsController < ApplicationController
  require 'rest-client'

  def index
    RSpotify.authenticate(Figaro.env.spotify_client_id, Figaro.env.spotify_secret_key)
    @songs = RSpotify::Track.search("Love Somebody")
  end

  def show
    @song = Song.find_by_id(params[:id])
    @song_section = SongSection.new
    return render_not_found if @song.blank?
  end

  def new
  end

  def search
  end

  def search_results
    @results = RSpotify::Track.search(params[:query])
  end

  def create
  end

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize}", status: status
  end

  def sterilize_labels(label)
    label = label.split('/')
    label.map! { |l| l.downcase.gsub(' ','_') }
  end
end
