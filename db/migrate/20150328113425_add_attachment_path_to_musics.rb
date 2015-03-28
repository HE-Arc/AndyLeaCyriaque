class AddAttachmentPathToMusics < ActiveRecord::Migration
  def self.up
    change_table :musics do |t|
      t.attachment :path
    end
  end

  def self.down
    remove_attachment :musics, :path
  end
end
