class Music < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
   
   has_attached_file :cover,
   :styles => {
     :thumb => "75x75#",
     :small => "100x100#",
     :medium => "150x150>"
     }, 
    :default_url => "user-undefined.png"
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
  
  has_attached_file :path
  validates_attachment_presence :path
  validates_attachment_content_type :path, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ]
  validates_attachment_size :path, :less_than => 20.megabytes
  
  has_many :music_playlists
  has_many :playlists, :through => :music_playlists
  has_many :comments

  letsrate_rateable "autism_friendly", "overall"
  
end
