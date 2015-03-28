class RemovePathFromMusics < ActiveRecord::Migration
  def change
    remove_column :musics, :path, :string
  end
end
