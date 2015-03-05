class RemoveIsAdminFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :isAdmin, :boolean
  end
end
