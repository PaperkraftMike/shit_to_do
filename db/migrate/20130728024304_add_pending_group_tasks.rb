class AddPendingGroupTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :pending, :boolean
  end

  def down
    drop_column :tasks, :pending, :boolean
  end
end
