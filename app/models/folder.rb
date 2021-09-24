class Folder < ApplicationRecord
  validates :title, presence: true

  has_many :content_folder_links, dependent: :destroy
  has_many :contents, through: :content_folder_links
  has_many :parents_folder_links, class_name: 'FolderLink', foreign_key: 'child_id', dependent: :destroy
  has_many :children_folder_links, class_name: 'FolderLink', foreign_key: 'parent_id', dependent: :destroy
  has_many :parents_folders, through: :parents_folder_links, source: :parent
  has_many :children_folders, through: :children_folder_links, source: :child
  has_many :folder_categories, dependent: :destroy
  has_many :categories, through: :folder_categories

  include PgSearch::Model
  pg_search_scope :search_folders,
    against: [ :title ],
    associated_against: {
      categories: :title
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents,
    order_within_rank: "folders.updated_at DESC"

  def duration
    self.children_contents.map{|x| x.duration}.sum
  end

  def children_contents
    self.children_folders&.map{|x| x&.contents}&.flatten&.sort_by{|y| y.title} + self.contents&.sort_by{|y| y&.title}
  end

  def children_categories
    self.children_contents&.map{|x| x.categories}&.flatten
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
end
