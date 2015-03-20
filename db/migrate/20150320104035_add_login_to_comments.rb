class AddLoginToComments < ActiveRecord::Migration
  def change
    add_column :comments, :login, :string
  end
end
