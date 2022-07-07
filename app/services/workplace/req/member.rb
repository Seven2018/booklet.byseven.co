class Workplace::Req::Member < Workplace::Req::Base

  def initialize(url, opts={})
    @url = "#{GRAPH_API}/#{opts[:id] || opts[:email]}"
    params
  end

  def email
    (data || {})['email'] 
  end

  def name
    (data || {})['name']
  end

  def picture
    (data || {}).dig('picture', 'data', 'url')
  end

  def lastname
    (data || {})['last_name']
  end

  def firstname
    (data || {})['first_name']
  end

  private

  def params
    @params ||= {
      access_token: ACCESS_TOKEN,
      fields: 'name,email,picture,first_name,last_name'
    }
  end
end
