class MusicsController < ApplicationController
  
  def new
    @music = Music.new
  end

  def create
    @music = Music.new(get_params)
    if @music.save
      redirect_to @music
    else
      render 'new'
    end
  end 
  
  def show
    @music = Music.find(params[:id])
    @comments = @music.comments
    @comment = @music.comments.build
  end

  private
  def get_params
        params.require(:music).permit(:music)
  end
end