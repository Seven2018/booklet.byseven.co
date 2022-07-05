class InterviewSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :label,
    :starts_at,
    :ends_at,
    :date,
    :status
  )

  belongs_to :employee
  belongs_to :interviewer
  belongs_to :interview_form
end
