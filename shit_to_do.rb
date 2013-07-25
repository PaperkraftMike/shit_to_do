require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

set :database, "sqlite3:///shit_to_do.sqlite3"

require './models.rb'

get '/' do
	haml :home
end

get '/signin' do
	haml :signin
end

get '/signup' do
	haml :signup
end

get '/about' do
	haml :about
end

get '/profile' do
	haml :profile
end

get '/tasks' do
	haml :tasks
end