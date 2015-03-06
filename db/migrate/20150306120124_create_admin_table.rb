class CreateAdminTable < ActiveRecord::Migration
  def change
    create_table :admin_tables do |t|
      t.references :user, index: true
    end
  end
end
