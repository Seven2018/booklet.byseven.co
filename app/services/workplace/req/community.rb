class Workplace::Req::Community < Workplace::Req::Base

  def initialize(url, opts={})
    @url = "#{GRAPH_API}/community"
    @params = {}.merge(access_token: ACCESS_TOKEN)
  end

  def result
    data
  end

  def big_mamma?
    data['name'] == "Big Mamma"
  end
end
