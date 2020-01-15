class Request < ApplicationRecord
  belongs_to :user
  belongs_to :training_program
end
