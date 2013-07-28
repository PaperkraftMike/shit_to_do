require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

configure(:development){set :database, "sqlite3:///shit_to_do.sqlite3"}

require './models.rb'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require 'gravtastic'

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
	@user = User.where(:email => params[:email]).first
	if @user
		if @user.password == params[:password]
			session[:user_id] = @user.id
			redirect '/users/' + @user.id.to_s
	    else
	    	redirect '/'
	    end
	else
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
  redirect 'users/' + @user.id.to_s
end

post '/confirmfriend/:id' do
  @user = current_user
  @friendship = Friendship.find(params[:id])
  @friendship.confirmed = true
  @friendship.save
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
  redirect '/'
end

post '/confirmtask/:id' do
  @user = current_user
  @task = Task.find(params[:id])
  @task.approved = true
  @task.pending = nil
  @task.save
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
  @found_users = User.all(:fname => params[:search])
  @found_tasks = Tasks.all(:tname => params[:search])
  haml :searchresults
end








  



