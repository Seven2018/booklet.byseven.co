class CsvImportUser < ApplicationRecord
  belongs_to :creator, class_name: "User", optional: true

  enum state: {
    pending: 0,
    processed: 10
  }
end
