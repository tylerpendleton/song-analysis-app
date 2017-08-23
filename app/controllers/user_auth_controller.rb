class UserAuthController < ApplicationController
  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:spotify_user] = spotify_user.to_hash 
    redirect_to root_path, notice: "Thank you for signing in #{spotify_user.display_name}!"
  end

  def sign_out
    session[:spotify_user] = nil
    redirect_to root_path, notice: "You have successfully signed out"
  end
end
