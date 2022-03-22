class CampaignDecorator < Draper::Decorator
  delegate_all

  def completion_status
    if completion_for(:all) == 0
      'not_started'
    elsif completion_for(:all) == 100
      'completed'
    else
      'in_progress'
    end
  end

  def completion_status_string
    completion_status.capitalize.gsub(/_/, " ")
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
      .map{ |interview| poro_campaign.send interview }
  end

  def employees_for(interviewer_id)
    User.joins(:interviews).where(interviews: {campaign: self, interviewer_id: interviewer_id}).distinct.order(lastname: :asc)
  end
end
