class SongSectionsController < ApplicationController
  def create
    @song = Song.find_by_id(params[:song_section][:song_structure_id])
    if @song.song_structure == nil
      @structure = SongStructure.create!(song_id: @song.id)
    else
      @structure = @song.song_structure
    end
    @section = @structure.song_sections.create(section_params)
    redirect_to song_path(@song)
  end

  private

  def section_params
    hash = params.require(:song_section).permit(:section, :lyrics)
    inst = split_instrumentation(params[:song_section][:instrumentation])
    hash[:instrumentation] = inst
    hash
  end

  def split_instrumentation(string)
    array = string.split(', ')
  end
end
