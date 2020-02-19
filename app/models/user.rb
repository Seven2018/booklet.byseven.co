class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :requests, dependent: :destroy
  has_many :attendees, dependent: :destroy
  belongs_to :company, optional: true
  has_many :user_teams, dependent: :destroy
  has_many :teams, through: :user_teams
  has_many :notifications, dependent: :destroy
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
      user = User.new(row.to_hash)
      user.company_id = Current.user.company_id
      user.save
    end
  end
end
