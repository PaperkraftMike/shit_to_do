require 'gravtastic'

class User < ActiveRecord::Base

  before_save :encrypt_password

  def full_name
  	fname + " " + lname
  end

  def full_location
    city + ", " + state
  end

  def encrpyt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password)
    user = User.where(:email => email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  include Gravtastic
  gravtastic

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