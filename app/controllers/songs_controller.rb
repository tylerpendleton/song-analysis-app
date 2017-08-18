class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def show
    @song = Song.find_by_id(params[:id])
    return render_not_found if @song.blank?
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.create(song_params)
    if @song.valid?
      redirect_to root_path
    else
      return render_not_found(:unprocessable_entity)
    end
  end

  private

  def song_params
    params.require(:song).permit(:title, :key, :tempo, :length)
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize}", status: status
  end
end
