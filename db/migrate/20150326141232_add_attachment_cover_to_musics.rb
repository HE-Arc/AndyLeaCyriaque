class AddAttachmentCoverToMusics < ActiveRecord::Migration
  def self.up
    change_table :musics do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :musics, :cover
  end
end
