require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

set :database, "sqlite3:///shit_to_do.sqlite3"

require './models.rb'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'

enable :sessions
use Rack::Flash, :sweep => true

set :sessions => true

helpers do 
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
    end
 end 

get '/' do
	haml :home
end

<<<<<<< HEAD
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
