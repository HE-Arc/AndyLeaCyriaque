class RemoveEmailAndPasswordFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :email, :string
    remove_column :users, :password, :string
  end
end
