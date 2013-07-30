class AddSharingToUser < ActiveRecord::Migration
  def up
    add_column :tasks, :task_public, :boolean 
    add_column :tasks, :task_private, :boolean  
  end

  def down
    remove_column :tasks, :task_public, :boolean 
    remove_column :tasks, :task_private, :boolean
  end
end
