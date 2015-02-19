class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :nom
      t.references :music, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
