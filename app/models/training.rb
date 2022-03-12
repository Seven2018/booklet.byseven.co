class Training < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :attendees, through: :sessions
  has_many :workshops, through: :sessions

  belongs_to :company
  belongs_to :creator, class_name: "User"
  belongs_to :folder, optional: true

  validates :title, presence: true

  paginates_per 10

  include PgSearch::Model
  pg_search_scope :search_trainings,
    against: [ :title ],
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents


  def past?
    past_sessions = []
    self.sessions.each do |session|
      if session.workshop.content_type == "Synchronous"
        past_sessions << self.id if session.date.present? && session.date < Date.today
      elsif session.workshop.content_type == "Asynchronous"
        unless session.available_date.nil? || session.available_date > Date.today
          past_sessions << self.id
        end
      end
    end
    return past_sessions.count == self.sessions.count
  end

  def done?
    attendees.distinct.pluck(:status).none?("Not completed")
  end

  def done_for?(user_id)
    attendees.where(user_id: user_id).distinct.pluck(:status).none?("Not completed")
  end

  def duration
    workshops.map(&:duration).sum
  end

  def employees
    User.joins(:attendees).where(attendees: {session_id: sessions.ids}).distinct
  end

  def synchronous?
    sessions.any? { |session| session.workshop.content_type == "Synchronous"}
  end

  def asynchronous?
    sessions.any? { |session| session.workshop.content_type == "Asynchronous"}
  end

  def next_session
    sessions.where('date >= ?', Time.zone.today).order(date: :asc).first
  end

  def next_date
    next_session&.date
  end

  def children_contents
    self.folder.children_folders&.map{|x| x&.contents}&.flatten&.sort_by{|y| y.title} + self.contents&.sort_by{|y| y&.title}
  end

  def children_categories
    self.folder.children_contents&.map{|x| x.categories}&.flatten
  end

  def children_types
    self.folder.children_contents&.map{|x| x.content_type}&.flatten
  end

  def folder_level
    max_level = 0
    self.children_folders.each do |child|
      level = 1
      if child.children_folders.present?
        level += 1
      end
      child.folder_level
      max_level = level if level > max_level
    end
    return max_level
  end

  def folder_to_hash(node = nil)
    if node.nil?
      node = self
    end
    result_hash = {type: node.class.name, name: node.title, children: []}
    node.children_folders.each do |folder|
      result_hash[:children] << folder_to_hash(folder)
    end
    node.contents.each do |content|
      result_hash[:children] << {type: content.class.name, name: content.title}
    end
    return result_hash
  end

  def children_folders_all(exclude_direct_children = false, node = nil)
    if node.nil?
      node = self
    end
    result_array = [node]
    node.children_folders.each do |folder|
      result_array << children_folders_all(false, folder)
    end
    if exclude_direct_children
      return result_array.flatten.uniq - [self] - self.children_folders
    else
      return result_array.flatten.uniq - [self]
    end
  end

  private

  def time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    return "#{hours}h#{rest unless rest == 0}"
  end
end
