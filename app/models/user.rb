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
  # validates :gender, inclusion: { in: ['M', 'F'] }

  def fullname
    "#{firstname} #{lastname}"
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    # unless user
    #     user = User.create(name: data['name'],
    #        email: data['email'],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
  end
end
