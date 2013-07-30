class ChangeTdateToDateObj < ActiveRecord::Migration
  def up
    add_column :tasks, :task_date, :date
    remove_column :tasks, :tdate, :string
  end

  def down
    remove_column :tasks, :task_date, :date
    add_column :tasks, :tdate, :string
  end
end
