require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  describe "songs#index action" do
    it "should load successfully" do
      get :index
      expect(response).to have_http_status(:success)
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
