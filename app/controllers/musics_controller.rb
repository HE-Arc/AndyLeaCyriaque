class MusicsController < ApplicationController

    before_action :set_music, only: [:show, :edit, :update, :destroy]
    before_filter :check_permission, only: [:edit, :update, :destroy]
    layout false

    def edit
        render 'edit'
    end

    # GET /musics
    # GET /musics.json
    def index
        @musics = Music.all
        #if params[:search]
        # @musics = Music.search params[:search]#.order("created_at DESC")
        #else
        # @musics = Music.all#.order('created_at DESC')
        #end
    end

    def indexUser
        @title = 'My songs'
        @user = current_user
        @musics=Music.songsByUser current_user.id
        render 'index'
    end

    def indexLast
        @title = 'Last songs uploaded'
        @user = current_user
        @musics = Music.lastSong
        render 'index'
    end

    def search
        @title = 'Results for "' + params[:search] + '"'
        @user = current_user
        @musics = Music.search params[:search]#.order("created_at DESC")
        render 'index'
    end

    # GET /musics/new
    def new
        @music = Music.new
    end

    # POST /musics
    # POST /musics.json
    def create
        @music = Music.new(music_params)
        @user = current_user
        respond_to do |format|
            if @music.title.empty?
              @music.title=@music.path_file_name
            end
            if @music.save
                @user.musics<<@music
                format.html { redirect_to @music, notice: 'Your song was successfully created.' }
                format.json { render json: { :status => :created, :message => @music}, location: @music }
            else
                format.html { render :new }
                format.json { render json: { :status => :unprocessable_entity, :message => @music.errors.full_messages } }
            end
        end
    end

    # GET /musics/1
    # GET /musics/1.json
    def show
        @userId = Music.userId params[:id]

        @music = Music.find(params[:id])

        @comments = @music.comments
        @comment = @music.comments.build

        @playlists = Playlist.all
        @musicPlaylists = @music.music_playlists
        @musicPlaylist = @music.music_playlists.build

        respond_to do |format|
            format.html { render :show }
            format.json { render json: { :infos => @music, :path => @music.path.url[0...-11], :cover => @music.cover.url } }
        end

    end

    # PATCH/PUT /musics/1
    # PATCH/PUT /musics/1.json
    def update
        respond_to do |format|
            if @music.update(music_params)
                format.html { redirect_to @music, notice: 'Your song was successfully updated.' }
           	    format.json { render json: { :status => :updated, :message => @music}, location: @music }
            else
                format.html { render :edit }
                format.json { render json: { :status => :unprocessable_entity, :message => @music.errors.full_messages } }
            end
        end
    end

    # DELETE /musics/1
    # DELETE /musics/1.json
    def destroy
        respond_to do |format|
            if @music.destroy
                #format.html { render :index, notice: 'Your song has been deleted' }
                format.json { render json: { :status => :ok } }
            else
                format.json { render json: { :status => :error } }
            end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
        @music = Music.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
        #params[:music].require(:title, :path).permit(:title, :artist, :album, :path, :cover)
        params[:music].permit(:title, :artist, :album, :path, :cover, :style)
    end

    # Check user permission for the actions
    def check_permission
        @userId = Music.userId params[:id]
        @authorized = @userId == current_user.id
        respond_to do |format|
            format.html { redirect_to root_path, notice: 'You dont have enough permissions to be here' unless @authorized }
            format.json { render json: { :status => :error } unless @authorized }
        end
    end
end
