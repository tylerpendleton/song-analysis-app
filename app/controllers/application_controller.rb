class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'open-uri'

  before_action -> { UserAuth.all.each { |x| x.destroy if x.expired? } }

  private

  def create_user_auth
    spotify_info = spotify_access(:get_token, params[:code])
    RestClient.post(spotify_info[:url], spotify_info[:body]) { |response, request, result|
      case response.code
      when 200
	then
	spotify_response = json(response)
	UserAuth.current = UserAuth.create!(access_token: spotify_response[:access_token], token_type: spotify_response[:token_type], token_scope: spotify_response[:scope], expires_in: spotify_response[:expires_in], refresh_token: spotify_response[:refresh_token])
      else
	return
      end
    }
  end

  def spotify_access(option, param="")
    callback = ERB::Util.url_encode(user_auth_index_url)
    query = param.split(' ').join('%20')
    call = {}
    spotify = {
      spotify_authorize_url: "https://accounts.spotify.com/authorize" ,
      spotify_authorize_post_url: "https://accounts.spotify.com/api/token",
      spotify_api_profile: "https://api.spotify.com/v1/me",
      api_search: "https://api.spotify.com/v1/search?",
      api_get_track: "https://api.spotify.com/v1/tracks/#{param}",
      api_get_track_features: "https://api.spotify.com/v1/audio-features/#{param}",
      api_search_type: "&type=track",
      api_search_query: "q=#{query}",
      response_type_code: "&response_type=code",
      response_type_json: "&response_type=json",
      grant_type: "?grant_type=authorization_code",
      auth_code: "&code=#{param}",
      client_id: "?client_id=#{ENV['spotify_client_id']}",
      redirect_uri: ("&redirect_uri=#{callback}")
    }
    if UserAuth.current != nil
      spotify[:token_header] = { Authorization: "Bearer #{UserAuth.current.access_token}" }
    end

    case option
    when :authorize
      then
      call = { url: [spotify[:spotify_authorize_url], spotify[:client_id], spotify[:response_type_code], spotify[:redirect_uri]].join('') }
    when :get_token
      then call = { url: spotify[:spotify_authorize_post_url], body: { client_id: ENV['spotify_client_id'], client_secret: ENV['spotify_secret_key'], grant_type: 'authorization_code', code: param, redirect_uri: user_auth_index_url } }
    when :get_profile
      then
      call = { url: spotify[:spotify_api_profile] }
    when :search_tracks
      then
      call = { url: spotify[:api_search] + spotify[:api_search_query] + spotify[:api_search_type], header: spotify[:token_header] }
    when :get_track
      then
      call = { url: spotify[:api_get_track], header: spotify[:token_header] }
    when :get_track_features
      then
      call = { url: spotify[:api_get_track_features], header: spotify[:token_header] }
    else
    end
  end

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

end
