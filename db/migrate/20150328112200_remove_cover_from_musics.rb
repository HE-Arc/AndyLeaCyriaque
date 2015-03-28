class RemoveCoverFromMusics < ActiveRecord::Migration
  def change
    remove_column :musics, :cover, :string
  end
end
