class Workplace::Req::Base

  attr_accessor :url, :params

  ACCESS_TOKEN = ENV['WORKPLACE_ACCESS_TOKEN']
  FIRST_MAIL = ENV['WORKPLACE_FIRST_MAIL']
  GRAPH_API = 'https://graph.facebook.com'

  def initialize(url, opts={})
    @url = url
    @params = opts
  end

  def valid?
    ACCESS_TOKEN.present?
  end

  private

  def setup_url(url, params = {})
    "#{url}?#{params.to_query}"
  end

  def fetch(url_path)
    begin
      url = URI(url_path)
      res = Net::HTTP.get(url)
      JSON.parse(res)
    rescue
      {}
    end
  end

  def data
    @data ||= fetch(setup_url(@url, @params))
  end
end
