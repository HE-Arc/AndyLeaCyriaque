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
	validates_attachment_content_type :path, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3', 'audio/ogg', 'application/ogg', 'video/ogg', 'audio/flac' ]
	validates_attachment_size :path, :less_than => 20.megabytes

	has_many :music_playlists, :dependent => :delete_all
  has_many :playlists, :through => :music_playlists
	has_many :comments, :dependent => :delete_all

  letsrate_rateable "autism_friendly", "overall"
  
  def self.lastSong()
    self.all.order("created_at DESC")
  end
  
  def self.songsByUser(param)
    self.where("user_id=?", param)
  end
  
  def self.userId(param)
    self.find(param).user_id
  end
  
  def self.count(param)
    @nbMusic=Music.where(user_id="?", param).count;
    render json: nbMusic
  end

end
