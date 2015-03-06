class PlayerController < ApplicationController
	#before_action :authenticate_user!

	def show
		render 'player/player'
	end
end
