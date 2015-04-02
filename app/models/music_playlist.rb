class MusicPlaylist < ActiveRecord::Base
  belongs_to :music
  belongs_to :playlist
  
  def self.allMusic(params)
    self.where("playlist_id=?", params)
  end
end
