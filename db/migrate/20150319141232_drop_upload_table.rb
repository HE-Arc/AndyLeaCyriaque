class DropUploadTable < ActiveRecord::Migration
  def change
    drop_table :uploads
  end
end
