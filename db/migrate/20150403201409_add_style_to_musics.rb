class AddStyleToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :style, :string
  end
end
