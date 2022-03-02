class InterviewDecorator < Draper::Decorator
  delegate_all

  def completion_status
    if locked?
      'locked'
    elsif campaign.completion_for(employee) == 0
      'not_started'
    elsif campaign.completion_for(employee) == 100
      'completed'
    else
      'in_progress'
    end
  end
end
