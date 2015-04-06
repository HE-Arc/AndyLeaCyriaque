class CommentsController < ApplicationController
    def new
        @comment = Comment.new
    end

    def create
        @music = Music.find(params[:music_id])
        @comment = @music.comments.create(get_params)
        @user = current_user
        @comment.login = @user.login
        @user.comments << @comment
        #redirect_to @music
        respond_to do |format|
            if @comment.save
                format.html { redirect_to @music, notice: 'Comment was successfully created.' }
                format.json { render json: { :status => :created, :message => @comment} }
            else
                format.html { render :new }
                format.json { render json: { :status => :unprocessable_entity, :message => @comment.errors.full_messages } }
            end
        end
    end

    private
    def get_params
        params[:comment].permit(:user_id, :comment_id, :comment, :login)
    end
end
