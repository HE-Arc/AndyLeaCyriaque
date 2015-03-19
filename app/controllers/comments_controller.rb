class CommentsController < ApplicationController
  def create  
      @music = Music.find(params[:music_id])
      @music.comments.create(get_params)
      @user = current_user
      @user.comments = @music.comments
      redirect_to @music
  end
  
  private
  def get_params
    params[:comment].permit(:user_id, :comment_id, :comment)
  end
  
end