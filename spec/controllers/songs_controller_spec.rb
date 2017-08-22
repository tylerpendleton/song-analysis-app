require 'rails_helper'
include Spotify

RSpec.describe SongsController, type: :controller do
  before :all do

  end
  controller do

  end
  describe "songs#index action" do
    it "should load successfully" do
      get :index
      expect(response).to have_http_status(:success)
    end
    
    it "should expect @spotify to be the spotify_auth url" do
      get :index
      assert_equal assigns(:spotify), "https://accounts.spotify.com/authorize?client_id=30ae99fef9404798aa72edd17be545b9&response_type=code&redirect_uri=http%3A%2F%2Fsong.dev%2Fuser_auth"
    end
  end


  describe "songs#new action" do
    it "should load successfully" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "songs#create action" do
    it "should allow a user to create a song" do
      song = FactoryGirl.attributes_for(:song)
      post :create, params: { song: song }
      expect(response).to redirect_to root_path
      expect(Song.count).to eq 1
    end

    it "should reject invalid songs" do
      post :create, params: { song: { title: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Song.count).to eq 0
    end
  end

  describe "songs#show action" do
    it "should show the song if found" do
      song = FactoryGirl.create(:song)
      get :show, params: { id: song.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the song is not found" do
      get :show, params: { id: "IMASONG" }
      expect(response).to have_http_status(:not_found)
    end
  end

  

end
