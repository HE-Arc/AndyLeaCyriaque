class RenamePlaylistsName < ActiveRecord::Migration
  def change
      rename_column :playlists, :nom, :name
  end
end
