require 'bundler/setup'
require 'sinatra'
require 'hiredis'
require 'builder'
require 'json'
require 'em-net-http'

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

post '/location/:username' do
  loc = Location.new(params)
  content_type 'text/xml'
  post_doc = Builder::XmlMarkup.new
  post_doc.add do |add|
    add.doc do |doc|
      doc.field(params[:username], :name=>'name')
      doc.field(loc.to_s, :name=>'location')
    end
  end
  " TOM IS A NOOB #{loc.to_s}"
end