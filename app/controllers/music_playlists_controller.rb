class MusicPlaylistsController < ApplicationController

    def new
        @musicPlaylist  = MusicPlaylist.new
    end

    def create
        @musicPlaylist = MusicPlaylist.new(get_params)
        @permitPlaylist = Playlist.where("id=?", @musicPlaylist.playlist_id).first
        @authorized = @permitPlaylist.user_id == current_user.id
        if (@authorized)
          if @musicPlaylist.save
            redirect_to root_path, notice: 'Added to the playlist!'
          end
        else
          @musicPlaylist.destroy
          redirect_to root_path, notice: 'It is not your playlist!'
        end
    end

    def show
        @playlists = MusicPlaylist.all
    end

    def index
        @playlists = MusicPlaylist.all

    end

    private

    def get_params
        params.require(:music_playlist).permit(:music_id,:playlist_id)
    end
  
   

end
