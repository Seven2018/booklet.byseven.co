class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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
end
