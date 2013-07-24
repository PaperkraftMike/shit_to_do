class User < ActiveRecord::Base
  has_many :tasks 
end

class Task < ActiveRecord::Base
	belongs_to :user
end