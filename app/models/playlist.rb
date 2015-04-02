class Playlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :music
  
  has_many :music_playlists, :dependent => :delete_all
  has_many :musics, :through => :music_playlists
end
