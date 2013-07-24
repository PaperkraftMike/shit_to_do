class CreateTask < ActiveRecord::Migration
  def up
  	create_table :tasks do |t| 
  		t.string :tname
  		t.string :tdisc
  		t.datetime :created_at
  		t.datetime :completed_at
  		t.datetime :ttime
  		t.integer :user_id
  		t.integer :friend_id
  		t.string :location 
  end
 end

  def down
  	drop_table :tasks
  end
end
