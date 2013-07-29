require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

configure(:development){set :database, "sqlite3:///shit_to_do.sqlite3"}

require './models.rb'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require 'gravtastic'
require 'pony'
require 'bcrypt'

Pony.options = { :from => "gettingstuffdone123@gmail.com", :via => :smtp, :via_options => { 
    :address => 'smtp.gmail.com',
    :port           => '25',
    }}

enable :sessions
use Rack::Flash, :sweep => true

set :sessions => true

helpers do 
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
  end
end 

get '/' do
  @user = current_user
	haml :home
end


post '/signin' do
  @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "Welcome back!"
      redirect '/users/' + @user.id.to_s
    else
      flash[:notice] = "You're not a user yet, or you password is wrong."
      redirect '/signup'
    end
  end

get '/users/:id' do
	@user = User.find(params[:id])
	haml :profile
end

get '/tasks/:id' do
	@task = Task.find(params[:id])
	haml :task
end

get '/users/:id/addtask' do
	haml :new_task
end

post '/addtask' do
  @task = Task.create(params)
	@user = current_user
	@user.tasks << @task
	redirect 'users/' + @user.id.to_s
end

post '/users/signup' do
	User.create(params)
  @users = User.all
  flash[:notice] = "Thanks for signing up"
  Pony.mail({
    :from => "gettingstuffdone123@gmail.com",
    :to => params[:email],
    :subject => "Welcome to getting shit done",
    :body => "We're so happy to have you, and hope you enjoy being productive with us.",
    :via => :smtp,
    :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'gettingstuffdone123@gmail.com',
    :password             => 'shit_to_do',
    :authentication       => :plain, 
    :domain               => "localhost.localdomain" 
     }
    })
	redirect '/'
end

get '/signup' do 
	haml :signup
end

get '/signin' do
	haml :signin
end

post '/:id/completetask' do
	@task = Task.find(params[:id])
	@user = current_user
	@task.completed = true
  @task.completed_at = Time.now
  @task.save
	redirect 'users/' + @user.id.to_s
end

get '/signout' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out"
  redirect '/'
end

post '/users/addfriend/:id' do
  @friend = Friendship.create(:friend_id => params[:id])
  @user = current_user
  @friend.requested = true
  @friend.pending = true
  @user.friendships << @friend
  Pony.mail({
  :from => "gettingstuffdone123@gmail.com",
  :to => User.find(@friend.friend_id).email,
  :subject => "You have a new friend request!",
  :body => "#{User.find(@friend.friend_id)} wants to be friends. Log in to your account to view their profile.",
  :via => :smtp,
  :via_options => {
  :address              => 'smtp.gmail.com',
  :port                 => '587',
  :enable_starttls_auto => true,
  :user_name            => 'gettingstuffdone123@gmail.com',
  :password             => 'shit_to_do',
  :authentication       => :plain, 
  :domain               => "localhost.localdomain" 
   }
  })
  redirect 'users/' + @user.id.to_s
end

post '/confirmfriend/:id' do
  @user = current_user
  @friendship = Friendship.find(params[:id])
  @friendship.confirmed = true
  @friendship.save
  Pony.mail({
  :from => "gettingstuffdone123@gmail.com",
  :to => User.find(@friend.friend_id).email,
  :subject => "Your friend request was confirmed!",
  :body => "#{User.find(@friend.friend_id)} approved your friend request. Log in to your account to see their tasks and start sharing the productivity",
  :via => :smtp,
  :via_options => {
  :address              => 'smtp.gmail.com',
  :port                 => '587',
  :enable_starttls_auto => true,
  :user_name            => 'gettingstuffdone123@gmail.com',
  :password             => 'shit_to_do',
  :authentication       => :plain, 
  :domain               => "localhost.localdomain" 
   }
  })
  redirect 'users/' + @user.id.to_s
end

post '/destroyfriend/:id' do
  @user = current_user
  @friendship = Friendship.find(params[:id])
  @friendship.destroy
  redirect 'users/' + @user.id.to_s
end

post '/taskrequest/:id' do
  @user = current_user
  @task = Task.find(params[:id])
  @task.task_public = true
  @task.pending = true
  @task.friend_id = @user.id 
  @task.save
  Pony.mail({
  :from => "gettingstuffdone123@gmail.com",
  :to => User.find(@task.user_id).email,
  :subject => "#{User.find(@user.id)} someone wants to share your task!",
  :body => "#{User.find(@task.friend_id)} wants to be part of your to do list. Log in to your account to see what they want.",
  :via => :smtp,
  :via_options => {
  :address              => 'smtp.gmail.com',
  :port                 => '587',
  :enable_starttls_auto => true,
  :user_name            => 'gettingstuffdone123@gmail.com',
  :password             => 'shit_to_do',
  :authentication       => :plain, 
  :domain               => "localhost.localdomain" 
   }
  })
  redirect '/'
end

post '/confirmtask/:id' do
  @user = current_user
  @task = Task.find(params[:id])
  @task.approved = true
  @task.pending = nil
  @task.save
  Pony.mail({
  :from => "gettingstuffdone123@gmail.com",
  :to => User.find(@task.friend_id).email,
  :subject => "#{User.find(@friend_id)} your request to share a task has been approved!",
  :body => "#{User.find(@task.user_id)} has approved your request to share their task. Log in to your account to see what they want.",
  :via => :smtp,
  :via_options => {
  :address              => 'smtp.gmail.com',
  :port                 => '587',
  :enable_starttls_auto => true,
  :user_name            => 'gettingstuffdone123@gmail.com',
  :password             => 'shit_to_do',
  :authentication       => :plain, 
  :domain               => "localhost.localdomain" 
   }
  })
  redirect 'users/' + @user.id.to_s
end

post '/denytask/:id' do
  @user = current_user
  @task = Task.find(params[:id])
  @task.approved = false
  @task.friend_id = nil
  @task.save
  redirect 'users/' + @user.id.to_s
end

get '/search' do
  @found_users = User.where("fname LIKE ?", "%#{params[:search]}%")
  @found_tasks = Task.where("tname LIKE?", "%#{params[:search]}%")
  haml :searchresults
end








  



