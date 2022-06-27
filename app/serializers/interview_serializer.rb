class InterviewSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :status
  )

  belongs_to :employee
  belongs_to :interviewer
  belongs_to :interview_form
end
