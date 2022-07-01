
class CustomSerializer

  def self.serialize_interview_set(employee_ids, interviews, with_interviewer = nil)
    employee_ids.map do |employee_id|
      if with_interviewer
        manager_interview = interviews.find_by(interviewer: with_interviewer, employee_id: employee_id, label: 'Manager')
        employee_interview = interviews.find_by(interviewer: with_interviewer, employee_id: employee_id, label: 'Employee')
        crossed_interview = interviews.find_by(interviewer: with_interviewer, employee_id: employee_id, label: 'Crossed')
      else
        manager_interview = interviews.find_by(employee_id: employee_id, label: 'Manager')
        employee_interview = interviews.find_by(employee_id: employee_id, label: 'Employee')
        crossed_interview = interviews.find_by(employee_id: employee_id, label: 'Crossed')
      end
      {
        manager_interview: (ActiveModelSerializers::SerializableResource.new(
          manager_interview, {serializer: InterviewSerializer}
        ) if manager_interview),
        employee_interview: (ActiveModelSerializers::SerializableResource.new(
          employee_interview, {
          serializer: InterviewSerializer, include: %w[interview_form.categories employee interviewer]
        }) if employee_interview),
        crossed_interview: (ActiveModelSerializers::SerializableResource.new(
          crossed_interview, {serializer: InterviewSerializer
        }) if crossed_interview),
        status: interview_set_gen_status(employee_interview, manager_interview, crossed_interview)
      }
    end.select { |interview| interview[:employee_interview].present? || interview[:manager_interview].present? }
  end

  def self.interview_set_gen_status(employee_interview, manager_interview, crossed_interview)
    if (employee_interview.present? && employee_interview.not_started? && manager_interview.nil? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.not_started? && manager_interview.present? && manager_interview.not_started? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.not_started? && manager_interview.present? && manager_interview.not_started? && crossed_interview.present? && (crossed_interview.not_started? || crossed_interview.not_available_yet?))
      :not_started
    elsif (employee_interview.present? && employee_interview.in_progress? && manager_interview.nil? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.submitted? && manager_interview.present? && !manager_interview.submitted? && crossed_interview.nil? ||
        employee_interview.present? && !employee_interview.submitted? && manager_interview.present? && manager_interview.submitted? && crossed_interview.nil?) ||
      (crossed_interview.present? && !crossed_interview.submitted?)
      :in_progress
    elsif (employee_interview.present? && employee_interview.submitted? && manager_interview.nil? && crossed_interview.nil?) ||
      (employee_interview.present? && employee_interview.submitted? && manager_interview.present? && manager_interview.submitted? && crossed_interview.nil?) ||
      (crossed_interview.present? && crossed_interview.submitted?)
      :submitted
    end
  end
end
