require 'net/http'
class Solr
  def initialize(host='localhost', port='8983')
    @host, @port = host, port
  end
  
  def put(username, loc)
    t=''
    post_doc = Builder::XmlMarkup.new(:target=>t)
    post_doc.add(:overwrite=>'true') do |add|
      add.doc do |doc|
        doc.field(username, :name=>'id')
        doc.field(loc.to_s, :name=>'location')
        doc.field(username, :name=>'name')
      end
    end
    Net::HTTP.new(@host, @port).start do |http|
      req = Net::HTTP::Post.new('/solr/update?wt=json&indent=true')
      req['Content-Type'] = 'text/json'
      req.body = t
      res = http.request(req)
      res.body
    end
  end
end