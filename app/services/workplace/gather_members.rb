class Workplace::GatherMembers
  EMPTY_AVATAR='http://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'

  def initialize
    @company = Company.find(2) 
  end

  def valid?
    @company.name.upcase == 'BIG MAMMA' &&
      Workplace::Req::Base::ACCESS_TOKEN &&
      Workplace::Req::Base::FIRST_MAIL
  end

  def add_missing_pictures
    @company.users.where(picture: [nil, '', EMPTY_AVATAR]).each do |user|
      member = Workplace::Req::Member.new(nil, {email: user.email})
      user.update(picture: member.picture) if member.picture
    end
  end

  private

  def first_members
    @first_members ||= Workplace::Req::CompanyMembers.new(nil)
  end

  def users_creator(member_request)
    return unless valid?
    return unless Rails.env.staging? || Rails.env.development?
    members = member_request.result
    members.each do |member_data|
      if member_data[:id].present?
        member = Workplace::Req::Member.new(nil, {id: member_data[:id]})
        user = @company.users.find_by(email: member.email)
        User.create(email: member.email,
                    company_id: 2,
                    lastname: member.lastname,
                    firstname: member.firstname,
                    picture: member.picture,
                    password: SecureRandom.base36(24)) unless user
      end
    end
  end

  def gather_pictures
    next_request = first_members.after?
    users_updator(first_members)
    if next_request
      next_members = Workplace::Req::CompanyMembers.new(nil, {after: first_members.next_page})
      users_updator(next_members)
      next_request = next_members.after?
      while next_request == true
        next_members = Workplace::Req::CompanyMembers.new(nil, {after: next_members.next_page}) 
        users_updator(next_members)
        next_request = next_members.after?
      end
    end
  end

  def users_updator(member_request)
    members = member_request.result
    members.each do |member_data|
      if member_data[:id].present?
        member = Workplace::Req::Member.new(nil, {id: member_data[:id]})
        user = @company.users.find_by(email: member.email)
        user.update(picture: member.picture) if member.picture && user.present? && !user&.picture.present?
      end
    end
  end
end
