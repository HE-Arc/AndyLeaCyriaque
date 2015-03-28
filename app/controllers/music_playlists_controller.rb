class MusicPlaylistsController < ApplicationController
  def new
    @musicPlaylist  = MusicPlaylist.new
  end
  
  def create
     @musicPlaylist = MusicPlaylist.new(get_params)
     if @musicPlaylist.save
       redirect_to root_path, notice: 'Added to the playlist!'
    end

  end
  
  def show

  end
  
  private
  
    def get_params 
      params.require(:music_playlist).permit(:music_id,:playlist_id)
    end
    
end