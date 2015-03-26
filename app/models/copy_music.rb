class Music < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
   
  has_attached_file :cover,
   :styles => {
     :thumb => "75x75#",
     :small => "100x100#",
     :medium => "150x150>"
     }, :default_url => "user-undefined.png"
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
  
   has_attached_file :path
   before_save :extract_metadata
   serialize :metadata
  
  def audio?
    upload_content_type =~ %r{^audio/(?:mp3|mpeg|mpeg3|mpg|x-mp3|x-mpeg|x-mpeg3|x-mpegaudio|x-mpg)$}
  end
  
  def display_name
  @display_name ||= if audio? && metadata?
      artist, title = metadata.values_at('artist', 'title')
      title.present? ? [title, artist].compact.join(' - ').force_encoding('UTF-8') : upload_file_name
    else
      upload_file_name
    end
  end

  # Retrieves metadata for MP3s
  def extract_metadata
    return unless audio?
    path = upload.queued_for_write[:original].path
    open_opts = { :encoding => 'utf-8' }
    Mp3Info.open(path, open_opts) do |mp3info|
      self.metadata = mp3info.tag
    end
  end
  
  def to_jq_upload
    {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "delete_url" => upload_path(self),
      "delete_type" => "DELETE" 
    }
  end
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
