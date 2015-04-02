class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_filter :check_permission, only: [:edit, :update, :destroy]

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
    @playlist = Playlist.find(params[:id])
    @userId = Playlist.find(params[:id]).user_id
    @user = User.find(@userId)
    @musicsPlaylists = MusicPlaylist.where("playlist_id=?", params[:id]) 
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
  end
  
  #GET /playlists/id_user
  def indexUser
    @user = User.find(params[:id])
    @playlists = @user.playlists
    render 'index'
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @user = current_user
    @playlist = Playlist.new(get_params)
    respond_to do |format|
      if @playlist.save
        @user.playlists << @playlist
        format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(get_params)
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: 'Playlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

  def get_params 
    params.require(:playlist).permit(:user_id, :nom, :content)
    end
  
  def check_permission
    @userId = Playlist.find(params[:id]).user_id
    @user = User.find(@userId)
    redirect_to root_path, notice: 'You dont have enough permissions to be here' unless @user==current_user
  end 
end
