class Workplace::Req::CompanyMembers < Workplace::Req::Base

  def initialize(url, opts={})
    @url = "#{GRAPH_API}/company/members/#{FIRST_MAIL}"
    @params = opts.with_indifferent_access.merge({access_token: ACCESS_TOKEN})
  end

  def result
    (data || {}).dig('data').each_with_object([]){|member, arr|  arr << {name: member['name'], id: member['id']}}
  end

  def ids
    (data || {}).dig('data').map{|member| member['id']}
  end

  def names
    (data || {}).dig('data').map{|member| member['name']}
  end

  def after?
    (data || {}).dig('paging', 'next').present?
  end

  def next_page
    (data || {}).dig('paging', 'cursors', 'after')
  end

  def next_company_members
    Workplace::Req::CompanyMembers.new(nil, {limit:25, after:after})
  end
end
