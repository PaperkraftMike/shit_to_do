class AddApprovalForTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :approved, :boolean
  end

  def down
    drop_column :tasks, :approved, :boolean
  end
end
