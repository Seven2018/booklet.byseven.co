class FolderLink < ApplicationRecord
  belongs_to :parent, class_name: 'Folder'
  belongs_to :child, class_name: 'Folder'
  validates :child_id, uniqueness: { scope: :parent_id }
end
