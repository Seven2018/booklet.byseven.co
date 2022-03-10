# frozen_string_literal: true

module InterviewUsersFilter
  private

  def filter_employees
    @employees = @campaign.employees

    params_interviewer_id = params.dig(:select, :interviewer_id) || params[:interviewer_id]

    @selected_interviewer =
      if params_interviewer_id.present?
        User.find(params_interviewer_id)
      elsif !current_user.hr_or_above? && @campaign.interviewers.uniq.include?(current_user)
        current_user
      end

    page_index = params.dig(:select, :page)&.to_i || 1

    @employees =
      @selected_interviewer.present? ?
        User.joins(:interviews).where(interviews: {campaign: @campaign, interviewer: @selected_interviewer}) :
        @campaign.employees


    total_employees_count = @employees.count
    @employees = @employees.distinct.order(lastname: :asc).page(page_index).per(10)
    @any_more = @employees.count * page_index < total_employees_count

    @campaign = @campaign.decorate
  end
end
