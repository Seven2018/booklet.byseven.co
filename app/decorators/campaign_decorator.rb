class CampaignDecorator < Draper::Decorator
  delegate_all

  def completion_status(employee = :all)
    if completion_for(employee) == 0
      'not_started'
    elsif completion_for(employee) == 100
      'completed'
    else
      'in_progress'
    end
  end

  def completion_status_string(employee = :all)
    completion_status(employee).capitalize.gsub(/_/, " ")
  end

  def campaign_type_str
    {
      # 'crossed' => 'Crossed', # TODO TEMPORARY
      'crossed' => '1 to 1',
      # 'simple' => 'Simple', # TODO TEMPORARY
      'simple' => '1 to 1',
      'one_to_one' => '1 to 1',
      'feedback_360' => 'Feedback 360'
    }[campaign_type]
  end

  def icon
    {
      'crossed' => 'uil:exchange',
      'simple' => 'uil:exchange',
      'one_to_one' => 'uil:exchange',
      'feedback_360' => 'mdi:star-shooting'
    }[campaign_type]
  end

  def interviews_for(employee_id)
    poro_campaign = Poro::Campaign.new(campaign: self, employee_id: employee_id)

    %i[employee_interview manager_interview crossed_interview]
      .map { |interview| poro_campaign.send interview }
  end

  def employees_for(interviewer_id)
    User.joins(:interviews).where(interviews: { campaign: self, interviewer_id: interviewer_id }).distinct.order(lastname: :asc)
  end

  def generate_interviews_status_sentence(employee_interview: nil, manager_interview: nil, crossed_interview: nil)
    if employee_interview&.not_started? && manager_interview&.not_started? ||
      employee_interview&.not_started? && manager_interview.nil? ||
      manager_interview&.not_started? && employee_interview.nil?
      I18n.t('campaigns.my_interviews.no_interview_started')
    elsif employee_interview&.in_progress? && manager_interview&.status&.to_sym != :in_progress || manager_interview&.in_progress? && employee_interview&.status&.to_sym != :in_progress
      I18n.t('campaigns.my_interviews.one_interview_in_progress')
    elsif employee_interview&.in_progress? && manager_interview&.in_progress?
      I18n.t('campaigns.my_interviews.two_interview_in_progress')
    elsif employee_interview&.submitted? && manager_interview&.in_progress? || employee_interview&.in_progress? && manager_interview&.submitted?
      I18n.t('campaigns.my_interviews.one_interview_submitted_and_one_interview_in_progress')
    elsif employee_interview&.submitted? && manager_interview&.not_started? || employee_interview&.not_started? && manager_interview&.submitted?
      I18n.t('campaigns.my_interviews.one_interview_submitted')
    elsif employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview&.not_started?
      I18n.t('campaigns.my_interviews.two_interviews_submitted_cross_review_available')
    elsif employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview&.in_progress?
      I18n.t('campaigns.my_interviews.two_interviews_submitted_cross_review_in_progress')
    elsif employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview&.submitted? ||
      employee_interview&.submitted? && manager_interview.nil? && crossed_interview.nil? ||
      employee_interview.nil? && manager_interview&.submitted? && crossed_interview.nil? ||
      employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview.nil?
      I18n.t('campaigns.my_interviews.all_interviews_submitted')
    else
      I18n.t('campaigns.my_interviews.no_status_to_show')
    end
  end
end
