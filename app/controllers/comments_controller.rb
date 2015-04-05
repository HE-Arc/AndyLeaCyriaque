class CommentsController < ApplicationController
  def new
    
  end
  
  def create  
      @music = Music.find(params[:music_id])
      @comment=@music.comments.create(get_params)
      @user = current_user
      @comment.login=@user.login
      @user.comments << @comment
      redirect_to @music
  end
  
  private
  def get_params
    params[:comment].permit(:user_id, :comment_id, :comment, :login)
  end
  
end