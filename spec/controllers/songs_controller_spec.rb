require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  describe "songs#index action" do
    it "should load successfully" do
      get :index
      expect(response).to have_http_status(:success)
    end
    
  end

  describe "songs#show action" do
    it "should show the song if found" do
      artist = FactoryGirl.create(:artist)
      song = FactoryGirl.create(:song, artist_id: artist.id)
      get :show, params: { id: song.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the song is not found" do
      get :show, params: { id: "IMASONG" }
      expect(response).to have_http_status(:not_found)
    end
  end

  

end
