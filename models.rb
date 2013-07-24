class User < ActiveRecord::Base

  def full_name
  	fname + " " + lname
  end

  has_many :tasks 
end

class Task < ActiveRecord::Base
	belongs_to :user
end