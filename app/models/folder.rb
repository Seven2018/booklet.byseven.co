class Folder < ApplicationRecord
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker
  validates :title, presence: true
  acts_as_tree order: "title"

  has_many :link_content_folders, dependent: :destroy
  has_many :contents, through: :link_content_folders

  def children_contents
    self.children.present? ? self.children.map{|x| x.contents}.flatten.sort_by{|y| y.title} : self.contents.sort_by{|y| y.title}
  end

  def children_categories
    self.children.present? ? self.children.map{|x| x.contents.map{|y| y.categories}}.flatten.uniq.sort_by{|z| z.title} : self.contents.map{|y| y.categories}.flatten.uniq.sort_by{|z| z.title}
  end
end
