class PlayerController < ApplicationController
	#before_action :authenticate_user!
	layout 'player'

	def home
		@user = current_user
	end

	def edit_playlist
		@user = current_user
		@playlist = Playlist.find(params[:id])
		render 'playlists/edit'
	end

	def show_playlist
		@user = current_user
		@playlist = Playlist.find(params[:id])
		render 'playlists/show'
	end

   def self.search(searchParam)
   if search
     Music.find(:all, :conditions => ['title LIKE ?', "%#{searchParam}%"])
   else
     Music.find(:all)
   end
 end
  
	def show_profile
		@user = User.find_by(login: params[:login]) #User.find(params[:login])
	end

end
