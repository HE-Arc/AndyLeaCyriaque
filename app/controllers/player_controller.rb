class PlayerController < ApplicationController
	#before_action :authenticate_user!

	def show_profile
		@user = User.find_by(login: params[:login]) #User.find(params[:login])
		render 'player/player'
	end

	def show
		@user = current_user
		render 'player/player'
	end
end
