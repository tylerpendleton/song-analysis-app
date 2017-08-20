class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'open-uri'

  before_action -> { UserAuth.all.each { |x| x.destroy if x.expired? } }

  private

  def spotify_access(option, code="")
    callback = ERB::Util.url_encode(user_auth_index_url)
    call = {}
    spotify = {
      spotify_authorize_url: "https://accounts.spotify.com/authorize" ,
      spotify_authorize_post_url: "https://accounts.spotify.com/api/token",
      spotify_api_profile: "https://api.spotify.com/v1/me",
      response_type_code: "&response_type=code",
      response_type_json: "&response_type=json",
      grant_type: "?grant_type=authorization_code",
      auth_code: "&code=#{code}",
      client_id: "?client_id=#{ENV['spotify_client_id']}",
      redirect_uri: ("&redirect_uri=#{callback}")
    }

    case option
    when :authorize
      then
      call = { url: [spotify[:spotify_authorize_url], spotify[:client_id], spotify[:response_type_code], spotify[:redirect_uri]].join('') }
    when :get_token
      then call = { url: spotify[:spotify_authorize_post_url], body: { client_id: ENV['spotify_client_id'], client_secret: ENV['spotify_secret_key'], grant_type: 'authorization_code', code: code, redirect_uri: user_auth_index_url } }
    when :get_profile
      then
      call = { url: spotify[:spotify_api_profile] }
    else
    end
  end

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end
end
