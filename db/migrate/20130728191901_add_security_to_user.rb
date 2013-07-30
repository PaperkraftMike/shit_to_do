class AddSecurityToUser < ActiveRecord::Migration
  def up
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
  end

  def down
    remove_column :users, :password_hash, :string
    remove_column :users, :password_salt, :string
    add_column :users, :password, :string
  end
end
