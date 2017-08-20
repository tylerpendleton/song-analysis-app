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
  
  def get_song(id)
      spotify = spotify_access(:get_track, id)
      RestClient.get( spotify[:url], spotify[:header] ) {| response, request, result | 
	if response.code == 200
	  song_info = json(response)
	  @song_params[:spotify_id] = id
	  @song_params[:title] = song_info[:name]
	  @song_params[:duration_ms] = song_info[:duration_ms]
	  @song_params[:explicit] = song_info[:explicit]
	  @song_params[:uri] = song_info[:uri]
	  @artist_params[:spotify_id] = song_info[:artists][0][:id]
	  @album_params[:spotify_id] = song_info[:album][:id]
	else
	  render json: response, status: response.code
	end
      }
  end

  def get_song_features(id)
      track_features = spotify_access(:get_track_features, id)
      RestClient.get( track_features[:url], track_features[:header] ) {| response, request, result | 
	if response.code == 200
	  features = json(response)
	  @song_params[:tempo] = features[:tempo]
	  @song_params[:time_signature] = features[:time_signature]
	  @song_params[:key] = features[:key]
	else
	  render json: response, status: response.code
	end
      }
  end

  def get_album(id)
      album_details = spotify_access(:get_album, id)
      RestClient.get( album_details[:url], album_details[:header] ) {| response, request, result |
	if response.code == 200
	  album = json(response)
	  @song_params[:copyright_text] = album[:copyrights][0][:text]
	  @song_params[:copyright_type] = album[:copyrights][0][:type]
	  @song_params[:label] = sterilize_labels(album[:label])
	else
	  render json: response, status: response.code
	end
      }
  end

  def get_and_create_artist(id)
      artist_details = spotify_access(:get_artist, id)
      RestClient.get( artist_details[:url], artist_details[:header] ) {| response, request, result |
	if response.code == 200
	  artist = json(response)
	  @artist_params[:name] = artist[:name]
	  @artist_params[:genres] = artist[:genres]
	  @artist_params[:image_large] = artist[:images][0][:url]
	  @artist_params[:image_medium] = artist[:images][1][:url]
	  @artist_params[:image_small] = artist[:images][2][:url]
	  if Artist.find_by(spotify_id: id) != nil
	    @current_artist = Artist.find_by(spotify_id: id)
	  else
	    @current_artist = Artist.create!(@artist_params) 
	  end
	else
	  render json: response, status: response.code
	end
      }
  end

  def song_search(query)
      query = ERB::Util.url_encode(query)
      spotify = spotify_access(:search_tracks, query)
      RestClient.get( spotify[:url], spotify[:header] ) {|response, request, result| 
	if response.code == 200
	  @results = json(response)[:tracks][:items]
	else
	  render json: response, status: response.code
	end
      }
  end

end
