class Folder < ApplicationRecord
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker
  validates :title, presence: true
  acts_as_tree order: "title"
end
