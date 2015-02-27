class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :nom
      t.references :user, index: true
      t.references :music, index: true
      t.text :content

      t.timestamps
    end
  end
end
