class ContentFolderLink < ApplicationRecord
  belongs_to :folder
  belongs_to :content
  validates :folder_id, uniqueness: { scope: :content_id }
end
