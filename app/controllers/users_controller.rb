class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = Post.new(get_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end  
  
  private
  def get_params
    params.require(:user).permit(:login, :firstname, :lastname, :birthday, :email, :password, [:avatar].original_filename, :isAdmin)
    end
end
