Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['spotify_client_id'], ENV['spotify_secret_key'], scope: 'user-modify-playback-state user-read-email user-read-private user-library-modify user-library-read'
end
