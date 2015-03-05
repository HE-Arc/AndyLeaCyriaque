class MusicsController < ApplicationController
  
  def new
    @music = User.new
  end

  def create
    @music = Post.new(get_params)
    if @music.save
      redirect_to @music
    else
      render 'new'
    end
  end  

  private
  def get_params
        params.require(:music).permit(:music)
  end
end