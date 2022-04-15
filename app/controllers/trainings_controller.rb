class TrainingsController < ApplicationController
  before_action :show_navbar_training

  def index
    @trainings = policy_scope(Training).order(created_at: :desc)
    @categories = Category.where(company_id: current_user.company_id)

    filter_trainings

    redirect_to my_trainings_path unless TrainingPolicy.new(current_user, nil).create?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @training = Training.find(params[:id])
    authorize @training

    # TEMP (Since Training contains only one Workshop)
    @workshop = @training.workshops.first
    @workshop_completed =
      Attendee.where(user: current_user, session: @workshop.sessions.ids).map(&:status).uniq.join == 'Completed'
  end

  def destroy
    @training = Training.find(params[:id])
    authorize @training

    @training.destroy

    respond_to do |format|
      format.html {redirect_to trainings_path}
      format.js
    end
  end

  def my_trainings
    trainings = Training.joins(sessions: :attendees).where(attendees: {user: current_user}).distinct
    authorize trainings

    trainings = trainings.search_trainings(params.dig(:search, :title)) if params.dig(:search, :title).present?

    if params.dig(:search, :period) == 'Completed'
      @trainings = trainings.where_not_exists(:attendees, {user: current_user, status: 'Not completed'})
    else
      @trainings = trainings.where_exists(:attendees, {user: current_user, status: 'Not completed'})
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def my_team_trainings
    trainings = Training.joins(sessions: :attendees).where(attendees: {user_id: current_user.employees.ids}).distinct
    authorize trainings

    @attendees = get_attendees_status(user_ids: current_user.employees.ids)
  end


  def my_team_trainings_user_details
    @user = User.find(params[:id])
    redirect_to my_team_trainings_path if @user.manager != current_user
    trainings = Training.joins(sessions: :attendees)
                 .where(attendees: {user: @user}).distinct

    authorize trainings

    @trainings_done = trainings.where_not_exists(:attendees, user: @user, status: 'Not completed')
    @trainings_to_do = trainings.where_exists(:attendees, user: @user, status: 'Not completed')
  end

  def send_acquisition_reminder_email
    workshop = Workshop.find_by(id: params.dig(:workshop_id))
    @training = Training.find_by(params.dig(:training_id))
    @training = workshop.training if @training.nil?
    authorize @training
    users =
      if params.dig(:training_id).present?
        @training.not_done_for_list
      else
        workshop.attendees.not_completed.map(&:user)
      end

    users.uniq.each do |user|
      # TO DO: UPDATE AS SOON AS A TRAINING CAN CONTAIN MULTIPLE WORKSHOPS
      TrainingMailer.with(user: user).training_reminder(user, @training).deliver_later
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def filter_trainings
    search_title = params.dig(:search, :title)
    search_period = params[:filter_tags].present? ? params.dig(:filter_tags, :period) : params.dig(:search, :period)

    @trainings =
      if search_period == 'All'
        @trainings
      elsif search_period == 'Completed'
        @trainings.where_not_exists(:sessions, 'date < ?', Time.zone.today)
      else
        @trainings.where_exists(:sessions, 'date >= ?', Time.zone.today)
      end

    # if (params.dig(:filter_tags) && params.dig(:filter_tags, :tag)).present? || params.dig(:search, :tags).present?
    #   selected_tags = params.dig(:search, :tags).present? ? params.dig(:search, :tags).split(',') : params.dig(:filter_tags, :tag).map{|x| x.split(':').last.to_i}
    #   selected_templates = InterviewForm.where(company_id: current_user.company_id).where_exists(:interview_form_tags, tag_id: selected_tags)
    #   @trainings = @trainings.where(interview_form_id: selected_templates.ids)
    #   @filtered_by_tags = 'true'
    # end

    if search_title.present?
      workshops =  Workshop.joins(:content).where(contents: {company_id: current_user.company_id}).search_workshops(search_title)
      folders = Folder.where(company_id: current_user.company_id).search_folders(search_title)
      trainings_by_workshops = Training.joins(:sessions).where(sessions: {workshop_id: workshops.ids}).ids
      trainings_by_folder = @trainings.where(folder_id: folders.ids).ids
      trainings = @trainings.search_trainings(search_title).ids
      @trainings = @trainings.where(id: (trainings_by_workshops + trainings_by_folder + trainings).uniq)
      @filtered = true
    else
      @filtered_by_tags = 'false'
      @filtered = false
    end

    page_index = params.dig(:search, :page).present? ? params.dig(:search, :page).to_i : 1

    total_trainings_count = @trainings.count
    @trainings = @trainings.page(page_index)
    @any_more = @trainings.count * page_index < total_trainings_count
  end

  def training_params
    params.require(:training).permit(:title, :folder_id, :auth_token)
  end

  def get_attendees_status(user_ids: nil)
    return [] if user_ids.blank?

    trainings = Attendee.where(user_id: user_ids).map{|x| x.session.training}.uniq
    completed, not_completed = {}, {}

    trainings.each do |training|

      user_ids.each do |user_id|

        if training.is_attended_by?(user_id)
          if training.done_for?(user_id)
            completed[user_id] = (completed[user_id].presence || 0) + 1
          else
            not_completed[user_id] = (not_completed[user_id].presence || 0) + 1
          end
        end

      end

    end

    attendee_ids = (completed.keys + not_completed.keys).uniq

    attendee_ids.map do |user_id|
      user_not_completed = not_completed[user_id].present? ? not_completed[user_id] : 0
      user_completed = completed[user_id].present? ? completed[user_id] : 0
      OpenStruct.new({user: User.find(user_id), to_do: user_not_completed, done: user_completed})
    end
  end
end
