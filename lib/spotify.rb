module Spotify

  class SpotifyClient
    def authorize
    end
  end
  def form_uri(task, arr=[])
    access_point = {
      authorize: "https://accounts.spotify.com/authorize",
      token:	"https://accounts.spotify.com/api/token",
      api:	"https://api.spotify.com/v1"
    }
    uri = access_point[task]

    if arr.count == 0
      return uri
    else
      last = ""
      arr.each_with_index do |a, i|

	if i == 0 && a.first != "/"
	  last = "?" + a
	  uri << last
	elsif i == 0
	  last = a
	  uri << last
	elsif i == 1 && last.first != '?'
	  last = "?" + a
	  uri << last
	else
	  last = "&" + a
	  uri << last
	end
      end

      uri
    end
  end

  def create_user_auth
    spotify_info = spotify_access(:get_token, params[:code])
    RestClient.post(spotify_info[:url], spotify_info[:body]) { |response, request, result|
      case response.code
      when 200
	then
	spotify_response = json(response)
	UserAuth.current = UserAuth.create!(access_token: spotify_response[:access_token], token_type: spotify_response[:token_type], token_scope: spotify_response[:scope], expires_in: spotify_response[:expires_in], refresh_token: spotify_response[:refresh_token])
      else
	render json: response, status: response.code
      end
    }
  end

  def spotify_access(option, param="")
    callback = ERB::Util.url_encode(user_auth_index_url)
    query = param.split(' ').join('%20')
    call = {}
    spotify = {
      api_profile: "https://api.spotify.com/v1/me",
      api_search: "/search",
      api_get_track: "/tracks/#{param}",
      api_get_track_features: "/audio-features/#{param}",
      api_get_artist: "/artists/#{param}",
      api_get_album: "/albums/#{param}",
      api_search_type: "type=track",
      api_search_query: "q=#{query}",
      response_type_code: "response_type=code",
      response_type_json: "response_type=json",
      grant_type: "grant_type=authorization_code",
      auth_code: "code=#{param}",
      client_id: "client_id=#{ENV['spotify_client_id']}",
      redirect_uri: ("redirect_uri=#{callback}")
    }
    if UserAuth.current != nil
      spotify[:token_header] = { Authorization: "Bearer #{UserAuth.current.access_token}" }
    end

    case option
    when :authorize
      then
      call = { url: form_uri(:authorize, [spotify[:client_id], spotify[:response_type_code], spotify[:redirect_uri]]) }
    when :get_token
      then call = { url: form_uri(:token), body: { client_id: ENV['spotify_client_id'], client_secret: ENV['spotify_secret_key'], grant_type: 'authorization_code', code: param, redirect_uri: user_auth_index_url } }
    when :search_tracks
      then
      call = { url: form_uri(:api, [spotify[:api_search], spotify[:api_search_query], spotify[:api_search_type]]), header: spotify[:token_header] }
    when :get_track
      then
      call = { url: form_uri(:api, [spotify[:api_get_track]]), header: spotify[:token_header] }
    when :get_track_features
      then
      call = { url: form_uri(:api, [spotify[:api_get_track_features]]), header: spotify[:token_header] }
    when :get_artist
      then
      call = { url: form_uri(:api, [spotify[:api_get_artist]]), header: spotify[:token_header] }
    when :get_album
      then
      call = { url: form_uri(:api, [spotify[:api_get_album]]), header: spotify[:token_header] }
    else
    end
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

  protected
  
  def app_authorize!

  end

end
