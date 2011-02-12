require 'net/http'
class Solr
  def initialize(host='localhost', port='8983')
    @host, @port = host, port
  end
  
  def put(username, loc)
    t=''
    post_doc = Builder::XmlMarkup.new(:target=>t)
    post_doc.add do |add|
      add.doc do |doc|
        doc.field(username, :name=>'id')
        doc.field(loc.to_s, :name=>'location')
      end
    end
    Net::HTTP.new(@host, @port).start do |http|
      req = Net::HTTP::Post.new('/solr/update?wt=json&indent=true')
      req['Content-Type'] = 'text/xml'
      req.body = t
      res = http.request(req)
      "#{res.code} #{res.body}"
    end
  end
end