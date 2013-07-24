require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

set :database, "sqlite3:///shit_to_do.sqlite3"

require './models.rb'


get '/' do
	haml :home
end

get '/user/:id' do
	@user = User.find(params[:id])
	haml :profile
end