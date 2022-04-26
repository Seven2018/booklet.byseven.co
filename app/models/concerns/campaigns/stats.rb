module Campaigns::Stats
  def stats
    data = interviews.group_by(&:employee_id).map do |employee_id, interviews|
      employee = User.find(employee_id)
      manager_interview = interviews.find(&:manager?)
      employee_interview = interviews.find(&:employee?)
      crossed_interview = interviews.find(&:crossed?)
      simple_interview = interviews.find(&:simple?)
      interviews = {}
      interviews[:manager_interview] = {
        id: manager_interview.id,
        interviewer_id: manager_interview.interviewer.id,
        answers_count: manager_interview.answers.count,
        completed: manager_interview.submitted?,
        locked_at: manager_interview.locked_at
      } if manager_interview

      interviews[:employee_interview] = {
        id: employee_interview.id,
        interviewer_id: employee_interview.interviewer.id,
        answers_count: employee_interview.answers.count,
        completed: employee_interview.submitted?,
        locked_at: employee_interview.locked_at
      } if employee_interview

      interviews[:crossed_interview] = {
        id: crossed_interview.id,
        interviewer_id: crossed_interview.interviewer.id,
        answers_count: crossed_interview.answers.count,
        completed: crossed_interview.submitted?,
        locked_at: crossed_interview.locked_at
      } if crossed_interview

      interviews[:simple_interview] = {
        id: simple_interview.id,
        interviewer_id: simple_interview.interviewer.id,
        answers_count: simple_interview.answers.count,
        completed: simple_interview.submitted?,
        locked_at: simple_interview.locked_at
      } if simple_interview

      {
        employee_id: employee.id,
        employee_email: employee.email,
        interviews: interviews
      }
    end

    {
      id: id,
      owner_id: owner.id,
      owner_email: owner.email,
      campaign_type: campaign_type,
      data: data
    }
  end
end
