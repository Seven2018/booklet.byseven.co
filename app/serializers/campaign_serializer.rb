class CampaignSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :title,
    :campaign_type,
    :employees_count,
    :completion,
    :deadline,
    :manager,
    # :interview_status_sentence,
    :manager_interview,
    :employee_interview,
    :crossed_interview,
    :employees_interviews,
    :status,
    :set_interviews
  )

  has_many :categories
  # has_many :employees, through: :interviews

  def employees_count
    if CampaignDraft.campaign(object.owner_id, object.id).any?
      'Adding participants...'
    else
      object.employees.distinct.count
    end
  end

  def completion
    return 0 if object.interviews.count.zero?

    return (object.interviews.submitted.count.fdiv(object.interviews.count) * 100).round

    # return 0 if object.interviews.where(employee: :all).count.zero?
    #
    # (
    #   object.interviews.submitted.where(employee: :all).count
    #             .fdiv(object.interviews.where(employee: :all).count) * 100
    # ).round
  end

  def manager
    return nil unless instance_options[:for_user]

    if instance_options[:schema] == 'manager'
      ActiveModelSerializers::SerializableResource.new(
        instance_options[:for_user],
        { serializer: UserSerializer }
      )
    else
      employee_interview = get_employee_interview_by_employee(instance_options[:for_user])
      ActiveModelSerializers::SerializableResource.new(
        employee_interview.interviewer,
        { serializer: UserSerializer }
      ) if employee_interview.present?
    end
  end

  # def interview_status_sentence
  #   return nil unless instance_options[:for_user]
  #
  #   generate_interviews_status_sentence(
  #     manager_interview: get_manager_interview_by_employee(instance_options[:for_user]),
  #     employee_interview: get_employee_interview_by_employee(instance_options[:for_user]),
  #     crossed_interview: get_crossed_interview_by_employee(instance_options[:for_user])
  #   )
  # end

  def manager_interview
    return nil unless instance_options[:for_user] && instance_options[:schema] != 'manager'

    interview = get_manager_interview_by_employee(instance_options[:for_user])
    {
      interview: {
        id: interview.id,
        status: interview.status,
        bg: interview_status_bg_class(interview),
        color: interview_status_color_class(interview),
      }
    } if interview.present?
  end

  def employee_interview
    return nil unless instance_options[:for_user] && instance_options[:schema] != 'manager'

    interview = get_employee_interview_by_employee(instance_options[:for_user])
    {
      interview: {
        id: interview.id,
        status: interview.status,
        bg: interview_status_bg_class(interview),
        color: interview_status_color_class(interview),
        status_sentence: generate_interviews_status_sentence(
          manager_interview: get_manager_interview_by_employee(instance_options[:for_user]),
          employee_interview: interview,
          crossed_interview: get_crossed_interview_by_employee(instance_options[:for_user])
        )
      }
    }
  end

  def crossed_interview
    return nil unless instance_options[:for_user] && instance_options[:schema] != 'manager'

    interview = get_crossed_interview_by_employee(instance_options[:for_user])
    {
      interview: {
        id: interview.id,
        status: interview.status,
        bg: interview_status_bg_class(interview),
        color: interview_status_color_class(interview),
      }
    } if interview.present?
  end

  def employees_interviews
    return nil unless instance_options[:for_user] && instance_options[:schema] == 'manager'

    users = User
              .joins(:interviews)
              .where(interviews: { campaign: object, interviewer: instance_options[:for_user] })
              .distinct
              .order(lastname: :asc)
    users.map do |user|
      employee_interview = Interview.find_by(interviewer: instance_options[:for_user], employee: user, label: 'Employee')
      manager_interview =  Interview.find_by(interviewer: instance_options[:for_user], employee: user, label: 'Manager')
      crossed_interview = Interview.find_by(interviewer: instance_options[:for_user], employee: user, label: 'Crossed')
        {
        employee: user,
        employee_interview: interview_serializer(def_interview: employee_interview, manager_interview: manager_interview, employee_interview: employee_interview, crossed_interview: crossed_interview),
        manager_interview: interview_serializer(def_interview: manager_interview, manager_interview: manager_interview, employee_interview: employee_interview, crossed_interview: crossed_interview),
        crossed_interview: interview_serializer(def_interview: crossed_interview, manager_interview: manager_interview, employee_interview: employee_interview, crossed_interview: crossed_interview),
      }
    end
  end

  def status
    interviews_count = object.interviews.count
    interviews_done = object.interviews.where(status: :submitted).count
    return :submitted if interviews_count == interviews_done

    interviews_not_started = object.interviews.where(status: [:not_started, :not_available_yet]).count
    return :not_started if interviews_count == interviews_not_started

    :in_progress
  end

  def set_interviews
    return nil if instance_options[:for_user].nil?

    employee_ids = instance_options[:schema] === 'manager' ? object.interviews.where(interviewer: instance_options[:for_user]).distinct.pluck(:employee_id) : [instance_options[:for_user].id]

    CustomSerializer.serialize_interview_set(employee_ids, object.interviews, instance_options[:schema] === 'manager' ? instance_options[:for_user] : nil)
  end

  private

  def interview_serializer(def_interview:, manager_interview:, employee_interview:, crossed_interview:)
    {
      interview: {
        id: def_interview.id,
        status: def_interview.status,
        bg: interview_status_bg_class(def_interview),
        color: interview_status_color_class(def_interview),
        status_sentence: generate_interviews_status_sentence(
          manager_interview: manager_interview,
          employee_interview: employee_interview,
          crossed_interview: crossed_interview
        )
      }
    } if def_interview.present?
  end

  def get_manager_interview_by_employee(for_user)
    object.interviews
          .where(employee: for_user)
          .find(&:manager?)
  end

  def get_employee_interview_by_employee(for_user)
    object.interviews
          .where(employee: for_user)
          .find(&:employee?)
  end

  def get_crossed_interview_by_employee(for_user)
    object.interviews
          .where(employee: for_user)
          .find(&:crossed?)
  end

  def generate_interviews_status_sentence(employee_interview: nil, manager_interview: nil, crossed_interview: nil)
    if employee_interview&.not_started? && manager_interview&.not_started? ||
      employee_interview&.not_started? && manager_interview.nil? ||
      manager_interview&.not_started? && employee_interview.nil?
      'No interview started'
    elsif employee_interview&.in_progress? && manager_interview&.status&.to_sym != :in_progress || manager_interview&.in_progress? && employee_interview&.status&.to_sym != :in_progress
      '1 interview in progress'
    elsif employee_interview&.in_progress? && manager_interview&.in_progress?
      '2 interview in progress'
    elsif employee_interview&.submitted? && manager_interview&.in_progress? || employee_interview&.in_progress? && manager_interview&.submitted?
      '1 interview submitted and 1 interview in progress'
    elsif employee_interview&.submitted? && manager_interview&.not_started? || employee_interview&.not_started? && manager_interview&.submitted?
      '1 interview submitted'
    elsif employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview&.not_started?
      '2 interviews submitted, Cross Review available'
    elsif employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview&.in_progress?
      '2 interviews submitted, Cross Review in progress'
    elsif employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview&.submitted? ||
      employee_interview&.submitted? && manager_interview.nil? && crossed_interview.nil? ||
      employee_interview.nil? && manager_interview&.submitted? && crossed_interview.nil? ||
      employee_interview&.submitted? && manager_interview&.submitted? && crossed_interview.nil?
      'All interviews submitted'
    else
      'no status to show'
    end
  end

  def interview_status_bg_class(interview)
    case interview.status.to_sym
    when :not_available_yet then 'bkt-bg-light-grey5'
    when :not_started then 'bkt-bg-red'
    when :in_progress then 'bkt-bg-yellow'
    when :submitted then 'bkt-bg-green'
    else
      'bkt-bg-black'
    end
  end

  def interview_status_color_class(interview)
    case interview.status.to_sym
    when :not_available_yet then 'bkt-light-grey5'
    when :not_started then 'bkt-red'
    when :in_progress then 'bkt-yellow'
    when :submitted then 'bkt-green'
    else
      'bkt-black'
    end
  end
end
