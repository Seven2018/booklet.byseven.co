
class InterviewFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at, :interview_question_count, :template_type

  has_many :categories

  def interview_question_count
    object.interview_questions.count
  end

  def template_type
    'InterviewForm'
  end
end
