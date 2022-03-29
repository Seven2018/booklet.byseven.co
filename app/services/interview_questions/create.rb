module InterviewQuestions
  class Create
    def self.call(**params)
      new(params).call
    end

    def initialize(question:, question_type:, interview_form_id:, position:)
      @position = position
      @form = InterviewForm.find interview_form_id
      @question = InterviewQuestion.new(
        question: question,
        question_type: question_type,
        interview_form: @form,
        position: @position
      )
    end

    def call
      target_position = @position.to_i + 1
      questions = @form.interview_questions.order(position: :asc)

      i = target_position
      questions.where('position >= ?', target_position).each do |question|
        question.update position: i
        i += 1
      end
      @question.position = target_position

      @question.options =
        if @question.rating?
          {'1' => 1}
        elsif @question.mcq? || @question.objective?
          {'Please enter an option': 1}
        end

      @question.visible_for = @form.answerable_by unless @form.answerable_by_both?

      @question.save
      return @question, @form
    end
  end
end
