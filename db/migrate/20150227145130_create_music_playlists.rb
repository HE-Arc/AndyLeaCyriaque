class CreateMusicPlaylists < ActiveRecord::Migration
  def change
    create_table :music_playlists do |t|
      t.references :music, index: true
      t.references :playlist, index: true

      t.timestamps
    end
  end
end
