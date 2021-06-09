class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :attendees, dependent: :destroy
  belongs_to :company, optional: true
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags
  has_many :user_forms, dependent: :destroy
  has_many :mods, through: :user_forms
  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests, source: :content
  validates :firstname, :lastname, :email, :access_level, presence: true
  # validates :gender, inclusion: { in: ['M', 'F'] }
  require 'csv'

  def fullname
    "#{firstname} #{lastname}"
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    user
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      #begin
        company_id = Current.user.company_id
        user_row = row.to_hash
        main_attr = "firstname,lastname,email,password,access_level,birth_date,hire_date,address,phone_number,social_security,gender,job_title".split(',')
        tag_attr = row.to_hash.keys - main_attr
        tag_attr.each do |tag|
          user_row.delete(tag)
        end
        user = User.new(user_row)
        user.company_id = company_id
        user.picture = 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'
        if !user.email.present?
          last_user = User.last
          user.email = 'user' + (last_user.id + 1).to_s + '@' + last_user.email.split('@').last
        end
        user.save
        raw, token = Devise.token_generator.generate(User, :reset_password_token)
        user.reset_password_token = token
        user.reset_password_sent_at = Time.now.utc
        user.save(validate: false)

        tag_attr.each do |x|
          category = TagCategory.where(company_id: company_id, name: x).first
          unless category.present?
            category = TagCategory.create(company_id: company_id, name: x)
          end
          tag = Tag.where(company_id: company_id, tag_category_id: category.id, tag_name: row[x]).first
          unless tag.present?
            tag = Tag.create(company_id: company_id, tag_category_id: category.id, tag_name: row[x])
          end
          UserTag.create(user_id: user.id, tag_id: tag.id)
        end
        # tag = row['tag']
        # existing_Tag = Tag.where(company_id: user.company_id, tag_name: row['tag'])
        # if existing_tag.present?
        #   UserTag.create(tag_id: existing_tag.first.id, user_id: user.id)
        # else
        #   Tag.create(tag_name: row['tag'], company_id: user.company_id)
        # end
        # UserMailer.account_created(user, raw).deliver
      #rescue
      #end
    end
  end
end
