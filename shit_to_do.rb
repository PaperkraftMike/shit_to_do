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

get '/users/:id' do
	@user = User.find(params[:id])
	haml :profile
end

get '/tasks/:id' do
	@task = Task.find(params[:id])
	haml :task
end

get '/users/:id/task/new' do
	@user = User.find(params[:id])
	haml :new_task
end

post '/users/:id/task/new' do
	@user = User.find(params[:id])
	@task = Task.create(params)
	@user << @task
	redirect 'users' + user.id.to_s
end

post '/users/signup' do
	User.create(params)
	redirect '/'
end

get '/signup' do 
	haml :signup
end


