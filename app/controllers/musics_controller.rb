class MusicsController < ApplicationController

    before_action :set_music, only: [:show, :edit, :update, :destroy]
    before_filter :check_permission, only: [:edit, :update, :destroy]
    autocomplete :music, :title
    layout false
  
    # GET /musics
    # GET /musics.json
    def index
        @musics = Music.all       

    def indexUser
        @user = current_user
        @musics=Music.songsByUser current_user.id
        render 'index'
    end

    def indexLast
        @user = current_user
        @musics = Music.lastSong
        render 'index'
    end

    def search
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
                #format.json { render :show, status: :created, location: @music }
                #format.html { render :show }
                format.json { render json: { :status => :created, :message => @music}, location: @music }
            else
                format.html { render :new }
                #format.json { render json: @music.errors.full_messages, status: :unprocessable_entity }
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
            format.json { render json: { :infos => @music, :path => @music.path.url[0...-11], :cover => @music.cover.url } }
        end

    end

    # PATCH/PUT /musics/1
    # PATCH/PUT /musics/1.json
    def update
        respond_to do |format|
            if @music.update(music_params)
                format.html { redirect_to @music, notice: 'Your song was successfully updated.' }
                format.json { render :show, status: :ok, location: @music }
            else
                format.html { render :edit }
                format.json { render json: @music.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /musics/1
    # DELETE /musics/1.json
    def destroy
        @music.destroy
        respond_to do |format|
            format.html { redirect_to musics_url, notice: 'Your song has been deleted' }
            format.json { head :no_content }
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
  
  def getMusicByName
    @musics = Music.order(:title).where("title like ?","%#{params[:search]}%")
    render json: @musics.map(&:title)
  end
  
    # Check user permission for the actions
    def check_permission
        @userId = Music.userId params[:id]

        redirect_to root_path, notice: 'You dont have enough permissions to be here' unless @user.id==current_user.id
    end
end
