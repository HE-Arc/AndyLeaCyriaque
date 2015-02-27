class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :login
      t.string :email
      t.string :password
      t.boolean :isAdmin
      t.date :birthday

      t.timestamps
    end
  end
end
