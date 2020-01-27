class ProgramCategory < ApplicationRecord
  belongs_to :training_program
  belongs_to :category
end
