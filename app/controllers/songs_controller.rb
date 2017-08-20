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
    return render_not_found if @song.blank?
  end

  def new
    spotify = spotify_access(:search_tracks)
  end

  def search
  end

  def search_results
    if params.has_key?(:query)
      query = params[:query].split(' ').join('%20')
      spotify = spotify_access(:search_tracks, query)
      RestClient.get( spotify[:url], spotify[:header] ) {|response, request, result| 
	if response.code == 200
	  @results = json(response)[:tracks][:items]
	end
      }
    end
  end

  def create
    @song_params = {}
    if params.has_key?(:spotify_id)
      spotify = spotify_access(:get_track, params[:spotify_id])
      RestClient.get( spotify[:url], spotify[:header] ) {| response, request, result | 
	if response.code == 200
	  song_info = json(response)
	  @song_params[:spotify_id] = song_info[:id]
	  @song_params[:title] = song_info[:name]
	  @song_params[:duration_ms] = song_info[:duration_ms]
	  @song_params[:explicit] = song_info[:explicit]
	  @song_params[:uri] = song_info[:uri]
	end
      }
      track_features = spotify_access(:get_track_features, params[:spotify_id])
      RestClient.get( track_features[:url], track_features[:header] ) {| response, request, result | 
	if response.code == 200
	  features = json(response)
	  @song_params[:tempo] = features[:tempo]
	  @song_params[:time_signature] = features[:time_signature]
	  @song_params[:key] = features[:key]
	end
      }
    end
    @song = Song.create(@song_params)
    if @song.valid?
      redirect_to root_path
    else
      return render_not_found(:unprocessable_entity)
    end
  end

  private


  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize}", status: status
  end


end
