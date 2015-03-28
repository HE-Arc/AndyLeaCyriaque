class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 has_attached_file :avatar,
   :styles => {
     :thumb => "75x75#",
     :small => "100x100#",
     :medium => "150x150>"
     }, :default_url => "user-undefined.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :playlists
  has_many :comments
  has_many :musics

  letsrate_rater
  
end
