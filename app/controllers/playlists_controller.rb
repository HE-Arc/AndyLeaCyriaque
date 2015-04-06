class PlaylistsController < ApplicationController
    before_action :set_playlist, only: [:show, :edit, :update, :destroy]
    before_filter :check_permission, only: [:edit, :update, :destroy]
    layout false

    # GET /playlists
    # GET /playlists.json
    def index
        @playlists = Playlist.all
    end

    def indexUser
        @playlists=Playlist.playlistsByUser current_user.id

        respond_to do |format|
            @user = current_user
            format.html { render action: :index }
        end
    end

    # GET /playlists/1
    # GET /playlists/1.json
    def show
        @user=current_user
        @playlist = Playlist.find(params[:id])
        @userId = Playlist.userId params[:id]
        @musicsPlaylists = MusicPlaylist.allMusic params[:id]
    end

    # GET /playlists/new
    def new
        @playlist = Playlist.new
    end

    # GET /playlists/1/edit
    def edit
    end

    # POST /playlists
    # POST /playlists.json
    def create
        @user = current_user
        @playlist = Playlist.new(get_params)
        respond_to do |format|
            if @playlist.name.empty?
                @playlist.name="playlist"+@playlist.id.to_s
            end
            if @playlist.save
                @user.playlists << @playlist
                format.html { redirect_to @playlist, notice: 'Your playlist was successfully created.' }
                format.json { render json: { :status => :created, :message => @playlist}, location: @playlist }
            else
                format.html { render :new }
                format.json { render json: { :status => :unprocessable_entity, :message => @playlist.errors.full_messages } }
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
        @playlist = Playlist.find(params[:id])
        respond_to do |format|
            if @playlist.destroy
                format.html { redirect_to @playlist, notice: 'Playlist was successfully destroyed.' }
                format.json { render :show, status: :ok, location: @playlist }
            else
                format.html { render :show }
                format.json { render json: @playlist.errors, status: :unprocessable_entity }
            end
        end
    end

    def count
        @nbPlaylist = Playlist.count;
        render json: nbPlaylist
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
        @playlist = Playlist.find(params[:id])
    end

    def get_params
        params.require(:playlist).permit(:user_id, :name, :content)
    end

    def check_permission
        @userId = Playlist.userId params[:id]
        @authorized = @userId == current_user.id
        respond_to do |format|
            format.html { redirect_to root_path, notice: 'You dont have enough permissions to be here' unless @authorized }
            format.json { render json: { :status => :error } unless @authorized }
        end
    end
end
