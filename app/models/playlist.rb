class Playlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :music
  
  has_many :music_playlists, :dependent => :delete_all
  has_many :musics, :through => :music_playlists
  
  def self.user(param)
    self.find(param).user_id
  end
  
  def self.playlistsByUser(param)
    self.where("user_id=?", param)
  end
  
  def self.count(param)
    @nbPlaylist=Playlist.where("user_id=?", param).count;
    render json: nbPlaylist
  end
  
  def self.count()
    @nbPlaylist = Playlist.count;
    render json: nbPlaylist
  end
end
