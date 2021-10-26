class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :attendees, dependent: :destroy
  has_many :sessions, through: :attendees
  belongs_to :company, optional: true
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags
  has_many :user_forms, dependent: :destroy
  has_many :mods, through: :user_forms
  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests, source: :content
  # validates :firstname, :lastname, :email, :access_level, presence: true
  validates :email, presence: true
  paginates_per 50
  # validates :gender, inclusion: { in: ['M', 'F'] }
  require 'csv'

  # SEARCHING USERS BY firstname and lastname
  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :firstname, :lastname ],
    associated_against: {
      tags: :tag_name,
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents


  def fullname
    "#{lastname.upcase} #{firstname.capitalize} "
  end

  def tag_from_category(category_id)
    self.tags.where(category_id: category_id)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    user
  end

  def self.import(file, company_id)
    present = []
    CSV.foreach(file.path, headers: true) do |row|
     # begin
        user_row = row.to_hash
        # User attributes
        main_attr = "firstname,lastname,email,password,access_level,birth_date,hire_date,address,phone_number,social_security,gender,job_title".split(',')
        # Tag_categories to create/use
        tag_attr = row.to_hash.keys - main_attr
        tag_attr.each do |tag|
          user_row.delete(tag)
        end
        # Create new user for the company provided as argument.
        # Skip rows without email address
        # if (user_row['email'].downcase =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/).nil?
        unless user_row['email'].present?
          next
        end
        user = User.find_by(email: user_row['email'].downcase)
        if user.present?
          # Only update if user belongs to the same company than current_user
          user.company_id == company_id ? user.update(user_row.except!('password')) : next
          update = true
        else
          user = User.new(user_row)
          user.company_id = company_id
          user.picture = 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'
          user.save
          raw, token = Devise.token_generator.generate(User, :reset_password_token)
          user.reset_password_token = token
          user.reset_password_sent_at = Time.now.utc
        end
        user.save(validate: false)
        present << user.id
        # Create tag_categories if necessary, correctly setting its position
        tag_category_last_position = TagCategory.where(company_id: company_id)&.order(position: :asc)&.last&.position
        tag_category_last_position = 0 if tag_category_last_position.nil?

        category = TagCategory.find_by(company_id: company_id, name: 'Job Title')
        unless category.present?
          category = TagCategory.create(company_id: company_id, name: 'Job Title', position: tag_category_last_position + 1)
          tag_category_last_position += 1
        end
        tag = Tag.find_by(company_id: company_id, tag_category_id: category.id, tag_name: row['job_title'])
        unless tag.present?
          tag = Tag.create(company_id: company_id, tag_category_id: category.id, tag_name: row['job_title'], tag_category_position: category.position)
        end
        previous_job = UserTag.find_by(user_id: user.id, tag_category_id: category.id)
        update_job = update.present? && previous_job.present?
        if update.present? && previous_job.present? && previous_job.tag_id != tag.id
          previous_job.update(tag_id: tag.id)
        elsif !previous_job.present?
          UserTag.create(user_id: user.id, tag_id: tag.id, tag_category_id: category.id)
        end
        tag_attr.each do |x|
          category = TagCategory.where(company_id: company_id, name: x).first
          unless category.present?
            category = TagCategory.create(company_id: company_id, name: x, position: tag_category_last_position + 1)
            tag_category_last_position += 1
          end
          tag = Tag.where(company_id: company_id, tag_category_id: category.id, tag_name: row[x]).first
          unless tag.present?
            tag = Tag.create(company_id: company_id, tag_category_id: category.id, tag_name: row[x], tag_category_position: category.position)
          end
          previous_tag = UserTag.find_by(user_id: user.id, tag_category_id: category.id)
          update = update.present? && previous_tag.present?
          if update && previous_tag.tag_id != tag.id
            previous_tag.update(tag_id: tag.id)
          elsif update && previous_tag.tag_id == tag.id
            next
          else
            UserTag.create(user_id: user.id, tag_id: tag.id, tag_category_id: category.id)
          end
        end
        # tag = row['tag']
        # existing_Tag = Tag.where(company_id: user.company_id, tag_name: row['tag'])
        # if existing_tag.present?
        #   UserTag.create(tag_id: existing_tag.first.id, user_id: user.id)
        # else
        #   Tag.create(tag_name: row['tag'], company_id: user.company_id)
        # end
        # UserMailer.account_created(user, raw).deliver
      # rescue
      # end
    end
    User.where(id: (User.where(company_id: company_id).map(&:id) - present)).each{|x| x.update(company_id: nil)}
  end

  def self.to_csv(attributes, tag_categories, cost, trainings, start_date, end_date)
    attributes = attributes.split(',')
    tag_categories_names = tag_categories.reject{|x| x.empty?}.map{|x| TagCategory.find(x).name}
    columns = attributes + tag_categories_names
    columns += ['Cost'] if cost == '1'
    columns += ['Trainings'] if trainings == '1'
    CSV.generate(headers: true) do |csv|
      csv << columns.flatten.reject{|x| x.empty?}
      all.each do |user|
        line = []
        attributes.flatten.each do |attribute|
          line << user.attributes[attribute]
        end
        tag_categories.reject{|x| x.empty?}.each do |tag_category|
          line << UserTag.find_by(user_id: user.id, tag_category_id: tag_category)&.tag&.tag_name if tag_category.present?
        end
        line << user.sessions.where('date >= ? AND date < ?', start_date, end_date).map{|x| x.cost / x.attendees.count}.sum if cost
        if trainings
          trainings = ''
          user.sessions.where('date >= ? AND date < ?', start_date, end_date).each{|s| trainings += s.content.title + "\n"}
          line << trainings.delete_suffix("\n")
        end
        csv << line
      end
    end
  end
end
