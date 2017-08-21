class SongsController < ApplicationController
  require 'rest-client'

  def index
    @songs = Song.all
    @spotify = spotify_access(:authorize)[:url]
    if UserAuth.current != nil
      @user_auth = UserAuth.current
    end
  end

  def show
    @song = Song.find_by_id(params[:id])
    @song_section = SongSection.new
    return render_not_found if @song.blank?
  end

  def new
    spotify = spotify_access(:search_tracks)
  end

  def search
  end

  def search_results
    if params.has_key?(:query)
      song_search(params[:query])
    end
  end

  def create
    @song_params = {}
    @artist_params = {}
    @album_params = {}

    if params.has_key?(:spotify_id)
      get_song(params[:spotify_id])
      get_song_features(params[:spotify_id])
      get_album(@album_params[:spotify_id])
      get_and_create_artist(@artist_params[:spotify_id])
    end

    @song = @current_artist.songs.create(@song_params)

    if @song.valid?
      @structure = SongStructure.create({song_id: @song.id})
      redirect_to root_path
    else
      return render_not_found(:unprocessable_entity)
    end
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
