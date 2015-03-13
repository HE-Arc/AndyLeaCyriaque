class MusicsController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  def index
    @musics = Musics.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @music.map{|music| music.to_jq_upload } }
    end
  end

  def show
    @music = Music.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @music }
    end
  end

  def new
    @music = Music.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @music }
    end
  end

  def edit
    @music = Music.find(params[:id])
  end

  def create
    @music = Music.new(params[get_params])

    respond_to do |format|
      if @music.save
        format.html {
          render :json => [@music.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
                format.json { render json: {files: [@music.to_jq_upload]}, status: :created, location: @music }
      else
        format.html { render action: "new" }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @music = Music.find(params[:id])
    respond_to do |format|
      if @music.update_attributes(params[:music])
        format.html { redirect_to @music, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @music = Music.find(params[:id])
    @music.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
    end
  end
    
  private
  def get_params
        params.require(:music).permit(:music)
  end
end