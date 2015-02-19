class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.integer :note
      t.string :path
      t.string :cover
      t.references :category, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
