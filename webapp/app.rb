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