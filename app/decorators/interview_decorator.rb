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

  def get_status_str
    status.gsub('_', ' ').capitalize
  end

  def get_status_bg_class
    case status.to_sym
    when :not_available_yet then 'bkt-bg-light-grey5'
    when :not_started then 'bkt-bg-red'
    when :in_progress then 'bkt-bg-yellow'
    when :submitted then 'bkt-bg-green'
    end
  end

  def get_status_color_class
    case status.to_sym
    when :not_available_yet then 'bkt-light-grey5'
    when :not_started then 'bkt-red'
    when :in_progress then 'bkt-yellow'
    when :submitted then 'bkt-green'
    end
  end
end
