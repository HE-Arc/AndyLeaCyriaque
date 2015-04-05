class DropAdminTable < ActiveRecord::Migration
  def change
    drop_table :admin_tables
  end
end
