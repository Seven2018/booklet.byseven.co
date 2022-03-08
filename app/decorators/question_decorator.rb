class QuestionDecorator < Draper::Decorator
  delegate_all

  def icon
    {
      'open_question' => 'bi:question-circle-fill',
      'mcq' => 'ant-design:check-square-filled',
      'objective' => 'fluent:target-arrow-24-filled',
      'rating' => 'codicon:star-full'
    }[question_type]
  end
end
