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

get '/users/:id/tasks/new' do
	@user = User.find(params[:id])
	haml :new_task
end

post '/users/:id/task/new' do
	@user = User.find(params[:id])
	@task = Task.create(params)
	@user << @task
	redirect 'users' + user.id.to_s
end

post '/signup' do
	User.create(params)
	redirect '/'
end

get '/signup' do 
	haml :signup
end

get '/signin' do
	haml :signin
end







