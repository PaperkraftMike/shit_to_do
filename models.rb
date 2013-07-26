class User < ActiveRecord::Base

  def full_name
  	fname + " " + lname
  end

  has_many :tasks 
  has_many :friends
end

class Task < ActiveRecord::Base
	belongs_to :user
end

class Friend <ActiveRecord::Base
  belongs_to :user
end