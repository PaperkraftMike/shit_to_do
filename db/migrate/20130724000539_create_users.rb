class CreateUsers < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :fname
  		t.string :lname
  		t.string :email
  		t.string :password
  		t.string :city
  		t.string :state
  		t.integer :zipcode
  		t.text :bio
  		t.integer :tasks
  	end
  end

  def down
  	drop_table :users
  end
end
