class AddContentToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :content, :text
  end
end
