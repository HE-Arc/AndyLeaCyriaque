class RemoveCategoryIdFromMusics < ActiveRecord::Migration
  def change
    remove_column :musics, :category_id, :integer
  end
end
