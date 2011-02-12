require 'bundler/setup'
require 'sinatra'
require 'hiredis'
require 'builder'
require 'json'

require File.dirname(__FILE__) +'/solr'

class Location
  attr_reader :lat, :lon
  
  def initialize(params)
    @lat, @lon = params[:lat], params[:lon]
  end
  
  def to_s
    "#{@lat},#{@lon}"
  end
end

class User
  
end

get '/' do
  content_type 'text/xml'
  '<hello/>'
end

get '/location/:username/:lat/:lon' do
  loc = Location.new(params)
  username = params[:username]
  content_type 'text/plain'
  Solr.new.put(username, loc)
end