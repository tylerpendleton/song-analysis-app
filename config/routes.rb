Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "songs#index"
  resources :songs do
    collection do
      post 'search_results'
      get 'search'
    end
  end
  resources :user_auth, only: [:index]
end
