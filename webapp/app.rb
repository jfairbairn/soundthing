require 'bundler/setup'
require 'sinatra'
require 'hiredis'
require 'builder'
require 'json'

require File.dirname(__FILE__) +'/solr'

class Location
  attr_reader :lat, :lng
  
  def initialize(params)
    @lat, @lng = params[:lat], params[:lng]
  end
  
  def to_s
    "#{@lat},#{@lng}"
  end
end

class User
  
end

get '/' do
  redirect '/mobile/index.html'
end

get '/mobile' do
  redirect '/mobile/index.html'
end

get '/location/:username/:lat/:lng' do
  loc = Location.new(params)
  username = params[:username]
  content_type 'text/plain'
  Solr.new.put(username, loc)
end

post '/location/:username' do
  loc = Location.new(params)
  username = params[:username]
  content_type 'text/json'
  Solr.new.put(username, loc)
end

USERS = {
  'tom' => 'pass',
  'james' => 'isanoob'
}

post '/mobile/signin' do
  spotifyname = params[:spotifyname]
  spotifypass = params[:spotifypass]
  
  if USERS[spotifyname] != spotifypass
    halt 403
  end
  
  response.set_cookie("spotifyname", spotifyname)
  response.set_cookie("spotifypass", spotifypass)
  redirect '/mobile/welcome.html'
end

get '/mobile/signout' do
  response.set_cookie('spotifyname', :expires => Time.now)
  response.set_cookie('spotifypass', :expires => Time.now)
  redirect '/mobile/index.html'
end