class Playlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :music
  
  has_many :music_playlists
  has_many :musics, :through => :music_playlists
end
