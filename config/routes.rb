Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "songs#index"
  resources :songs do
    collection do
      post 'search_results'
      get 'search'
      post '/play_song', to: 'songs#play_song'
    end
  end
  get 'auth/spotify/callback', to: 'user_auth#spotify'
  get 'auth/spotify/sign_out', to: 'user_auth#sign_out'
  resources :user_auth, only: [:index]
  resources :artists, only: [:index, :show]
  resources :song_sections, only: [:create, :update]
end
