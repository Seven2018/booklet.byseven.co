require 'csv'

class User < ApplicationRecord
  include Users::Access
  acts_as_token_authenticatable
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
  has_many :campaigns, through: :interviews
  has_many :interviews, foreign_key: 'employee_id'
  has_many :interview_answers
  validates :email, presence: true
  paginates_per 50
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
      row_h = row.to_hash
      user_attr = "firstname,lastname,email,password,access_level,birth_date,hire_date,address,phone_number,social_security,gender,job_title".split(',')
      tag_categories_to_create_user = row.to_hash.keys - user_attr
      tag_categories_to_create_user.each { |tag| row_h.delete(tag) }

      # Create new user for the company provided as argument.
      next unless
        row_h['email'].present? ||
        (row_h['email'].downcase =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)

      user = User.find_by(email: row_h['email'].downcase)
      if user.present?
        next unless user.company_id == company_id

        user.update(row_h.except!('password'))
        update = true
      else
        user = User.new(row_h)
        user.access_level = 'Employee' unless ['HR', 'Manager', 'Employee'].include?(row_h['access_level'])
        user.company_id = company_id
        user.picture = 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'
        user.authentication_token = Base64.encode64(user.email).gsub("\n","") + SecureRandom.hex(32)
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
      tag = Tag.find_by(company_id: company_id, tag_category: category, tag_name: row['job_title'])
      unless tag.present?
        tag = Tag.create(company_id: company_id, tag_category: category, tag_name: row['job_title'], tag_category_position: category.position)
      end
      previous_job = UserTag.find_by(user: user, tag_category: category)
      update_job = update.present? && previous_job.present?
      if update.present? && previous_job.present? && previous_job.tag_id != tag.id
        previous_job.update(tag_id: tag.id)
      elsif !previous_job.present?
        UserTag.create(user: user, tag_id: tag.id, tag_category: category)
      end
      tag_categories_to_create_user.each do |x|
        category = TagCategory.where(company_id: company_id, name: x).first
        unless category.present?
          category = TagCategory.create(company_id: company_id, name: x, position: tag_category_last_position + 1)
          tag_category_last_position += 1
        end
        tag = Tag.where(company_id: company_id, tag_category: category, tag_name: row[x]).first
        unless tag.present?
          tag = Tag.create(company_id: company_id, tag_category: category, tag_name: row[x], tag_category_position: category.position)
        end
        previous_tag = UserTag.find_by(user: user, tag_category: category)
        update = update.present? && previous_tag.present?
        if update && previous_tag.tag_id != tag.id
          previous_tag.update(tag_id: tag.id)
        elsif update && previous_tag.tag_id == tag.id
          next
        else
          UserTag.create(user: user, tag_id: tag.id, tag_category: category)
        end
      end
    end
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
          line << UserTag.find_by(user: user, tag_category: tag_category)&.tag&.tag_name if tag_category.present?
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
