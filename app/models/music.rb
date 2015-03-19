class Music < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  
  has_many :musicPlaylists
  has_many :comments
end
