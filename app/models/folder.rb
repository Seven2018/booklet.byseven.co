class Folder < ApplicationRecord
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker
  validates :title, presence: true
  acts_as_tree order: "title"

  has_many :content_folder_links, dependent: :destroy
  has_many :contents, through: :content_folder_links
  has_many :parents_folder_links, class_name: 'FolderLink', foreign_key: 'child_id', dependent: :destroy
  has_many :children_folder_links, class_name: 'FolderLink', foreign_key: 'parent_id', dependent: :destroy
  has_many :parents_folders, through: :parents_folder_links, source: :parent
  has_many :children_folders, through: :children_folder_links, source: :child

  def children_contents
    self.children.present? ? self.children.map{|x| x.contents}.flatten.sort_by{|y| y.title} : self.contents.sort_by{|y| y.title}
  end

  def children_categories
    self.children.present? ? self.children.map{|x| x.contents.map{|y| y.categories}}.flatten.uniq.sort_by{|z| z.title} : self.contents.map{|y| y.categories}.flatten.uniq.sort_by{|z| z.title}
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

  def folder_tree
    if self.children_folders.present?
      self.children_folders.each do |child|
        print "-"
        print "[#{child.title}]\n"
        child.folder_tree
      end
      self.contents.each do |content|
        print "-"
        print "#{content.title}\n"
      end
    else
      self.contents.each do |content|
        print "-"
        print "#{content.title}\n"
      end
    end
  end

  def tree_view(label_method = :to_s,  node = nil, level = -1)
    if node.nil?
      puts "root"
      nodes = self.children_folders
    else
      label = "|_ #{node.send(label_method)}"
      if level == 0
        puts " #{label}"
      else
        puts " |#{"    "*level}#{label}"
      end
      nodes = node.children_folders
    end
    nodes.each do |child|
      tree_view(label_method, child, level+1)
      # child.children_contents do |content|
      #   label = "|_ #{content.title}"
      #   if level == 0
      #     puts " #{label}"
      #   else
      #     puts " |#{"    "*level}#{label}"
      #   end
      # end
    end
  end
end
