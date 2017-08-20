module UserAuthHelper
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
end
