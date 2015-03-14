class RemoveMusicFromPlaylists < ActiveRecord::Migration
  def change
    remove_reference :playlists, :music, index: true
  end
end
