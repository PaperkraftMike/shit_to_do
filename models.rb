class User < ActiveRecord::Base

  def full_name
  	fname + " " + lname
  end

  def full_location
    city + ", " + state
  end


  has_many :tasks 
  has_many :friendships
  has_many :friends, :through => :friendships  
end

class Task < ActiveRecord::Base
	belongs_to :user
end

class Friendship <ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
end