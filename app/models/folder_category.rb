class FolderCategory < ApplicationRecord
  belongs_to :folder
  belongs_to :category
end
