class SongsController < ApplicationController
  require 'rest-client'
  skip_before_action :verify_authenticity_token, only: :play_song

  def index
    RSpotify.authenticate(Figaro.env.spotify_client_id, Figaro.env.spotify_secret_key)
    @songs = RSpotify::Track.search("Love Somebody")
    @spotify_user = RSpotify::User.new(session[:spotify_user]) unless session[:spotify_user] == nil
  end

  def show
    @song = Song.find_by_id(params[:id])
    @song_section = SongSection.new
    return render_not_found if @song.blank?
  end

  def play_song
    @spotify_user = RSpotify::User.new(session[:spotify_user]) unless session[:spotify_user] == nil
    @song = RSpotify::Track.find(params[:song_id])
    @spotify_user.play_track(@song.uri)
  end

  def new
  end

  def search
  end

  def search_results
    @spotify_user = RSpotify::User.new(session[:spotify_user]) unless session[:spotify_user] == nil
    @results = RSpotify::Track.search(params[:query], limit: 10)
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
