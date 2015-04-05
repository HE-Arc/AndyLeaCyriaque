class Music < ActiveRecord::Base
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
		@nbMusic=Music.where("user_id=?", param).count;
		render json: nbMusic
	end

  def music_title
    music.try(:title)
  end
  
  def music_title=(title)
    self.music = Music.find_or_create_by_name(title) if title.present?
  end
  
	def self.search(searchParam)
		#search_condition = "%" + search + "%"
		#self.find(:all, :conditions => ['title LIKE ? OR description LIKE ?', "%#{searchParam}%"])
		t = self.arel_table
		self.where(t[:title].matches("%#{searchParam}%").or(t[:artist].matches("%#{searchParam}%")).or(t[:style].matches("%#{searchParam}%"))).all
		#where("title LIKE ?", "%#{searchParam}%")
		#where("artist LIKE ?", "%#{searchParam}%")
		#render 'index'
	end

end
