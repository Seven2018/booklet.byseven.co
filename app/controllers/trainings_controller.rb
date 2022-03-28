class TrainingsController < ApplicationController
  before_action :show_navbar_admin, only: %i[index]
  before_action :show_navbar_training

  def index
    @trainings = policy_scope(Training).where(company_id: current_user.company_id)
                                       .order(created_at: :desc)
    @categories = Category.where(company_id: current_user.company_id)

    filter_trainings

    redirect_to my_trainings_path unless current_user.hr_or_above?

    respond_to do |format|
      format.html
      format.js
    end
  end

  # Outdated Index function
  # def index
  #   @trainings = Training.where(company: current_user.company)
  #   @employees_form = User.where(company: current_user.company)
  #   @types_form = ["Synchronous", "Asynchronous"]

  #   @recommendations = UserInterest.where(user_id: current_user.id)

  #   unless current_user.hr_or_above?
  #     @trainings = @trainings.joins(sessions: :attendees).where(attendees: { user_id: current_user.id }).distinct
  #     @recommendations = @recommendations.where(user_id: current_user.id)
  #   end

  #   # SEARCH TRAININGS
  #   if params[:search_trainings].present?
  #     unless params[:search_trainings][:title].blank?
  #       @trainings = @trainings.search_trainings("#{params[:search_trainings][:title]}")
  #     end
  #     unless params[:training][:categories].reject{|c| c.empty?}.blank?
  #       @trainings = @trainings.joins(folder: :folder_categories).where(folder_categories: {category_id: params[:training][:categories].reject{|c| c.empty?}.map{|x| x.to_i}}) + @trainings.joins(sessions: {workshop: {content: :content_categories}}).where(content_categories: {category_id: params[:training][:categories].reject{|c| c.empty?}.map{|x| x.to_i}})
  #       @trainings = Training.where(id: @trainings.map{|x| x.id})
  #     end
  #     if params[:search_trainings][:period] == 'All'
  #       @trainings = @trainings
  #     elsif params[:search_trainings][:period] == 'Current'
  #       @trainings = @trainings.where_exists(:sessions, 'date >= ?', Date.today).or(@trainings.where_exists(:sessions, 'available_date >= ?', Date.today))
  #     elsif params[:search_trainings][:period] == 'Completed'
  #       @trainings = @trainings.where_not_exists(:sessions, 'date >= ?', Date.today).where_not_exists(:sessions, 'available_date >= ?', Date.today)
  #     end
  #     if current_user.hr_or_above?
  #       unless params[:search_trainings][:employee].blank?
  #         selected_employee = User.search_by_name("#{params[:search_trainings][:employee]}").first
  #         @trainings = @trainings.joins(sessions: :attendees).where(attendees: { user_id: selected_employee.id }).distinct
  #       end
  #     end
  #     unless params[:search_trainings][:type].blank?
  #       @trainings = @trainings.joins(sessions: :workshop).where(workshops: {content_type: params[:search_trainings][:type]})
  #     end
  #   end

  #   # SEARCHING RECOMMENDATIONS
  #   if params[:search_recommendations].present?
  #     unless params[:search_recommendations][:title].blank?
  #       @recommendations = @recommendations.search_recommendations("#{params[:search_recommendations][:title]}")
  #     end
  #     if current_user.hr_or_above?
  #       unless params[:search_recommendations][:employee].blank?
  #         selected_employee = User.find(params[:search_recommendations][:employee])
  #         @recommendations = UserInterest.where(user_id: selected_employee.id)
  #       end
  #     end
  #     unless params[:search_recommendations][:type].blank?
  #       @recommendations = @recommendations.joins(:content).where(contents: {content_type: params[:search_recommendations][:type]})
  #     end
  #   end

  #   @pending_recommendations = @recommendations.where(recommendation: "Pending")
  #   @accepted_recommendations = @recommendations.where(recommendation: "Yes")
  #   @declined_recommendations = @recommendations.where(recommendation: "No")
  #   @answered_recommendations = @accepted_recommendations + @declined_recommendations

  #   # @current_trainings = @trainings.joins(:sessions).where('date >= ?', Date.today).or(@trainings.joins(:sessions).where(sessions: {date: nil})).order(date: :desc).uniq.reverse
  #   # @current_trainings = @trainings.sort_by { |training| training.next_session }
  #   @current_trainings = @trainings.where_exists(:sessions, 'date >= ?', Date.today).or(@trainings.where_exists(:sessions, 'available_date >= ?', Date.today))
  #   @pasts_trainings = (@trainings - @current_trainings)

  #   respond_to do |format|
  #     format.html {trainings_path}
  #     format.js
  #   end
  # end

  def my_trainings
    trainings = Training.joins(sessions: :attendees).where(attendees: {user: current_user})
    authorize trainings

    # raise if params.dig(:search, :title).present?
    trainings = trainings.search_trainings(params.dig(:search, :title)) if params.dig(:search, :title).present?

    if params.dig(:search, :period) == 'Completed'
      @trainings = trainings.select{|x| x.next_date.nil?}
    else
      @trainings = trainings.select{|x| x.next_date.present?}
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
    @trainings = Training.joins(sessions: :attendees)
                 .where(attendees: {user: @user}).distinct

    authorize @trainings

    @trainings = @trainings.select{|x| x.next_date.present?}
                 .sort{|y| y.next_date}

    @attendee_status = get_attendees_status(user_ids: params[:id]).first
    @attendees_done = Attendee.where(user_id: params[:id], status: 'Completed')
    @attendees_to_do = Attendee.where(user_id: params[:id], status: 'Not completed')
  end

  def create
    @training = Training.new(training_params)
    authorize @training
    @training.company_id = current_user.company_id
    if @training.save
      respond_to do |format|
        format.js
      end
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

  # TEMP (NOT USED ATM)
  # def send_reminder_email
  #   training = Training.find(params[:id])
  #   authorize training

  #   target_users = training.attendees.distinct.where(status: 'Not completed').map(&:user).uniq

  #   target_users.each do |user|
  #     TrainigMailer.with(user: user)
  #         .training_reminder(user, training)
  #         .deliver_now
  #   end

  #   flash[:notice] = 'Email(s) sent.'

  #   head :no_content
  # end

  def destroy
    @training = Training.find(params[:id])
    authorize @training

    @training.destroy

    respond_to do |format|
      format.html {redirect_to trainings_path}
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
        @trainings.where_not_exists(:sessions, 'date < ?', Date.today)
      else
        @trainings.where_exists(:sessions, 'date >= ?', Date.today)
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

    completed = Attendee.where(user_id: user_ids, status: 'Completed').group(:user_id).count
    not_completed = Attendee.where(user_id: user_ids, status: 'Not completed').group(:user_id).count
    attendee_ids = (completed.keys + not_completed.keys).uniq
    attendee_ids.map do |user_id|
      user_not_completed = not_completed[user_id].present? ? not_completed[user_id] : 0
      user_completed = completed[user_id].present? ? completed[user_id] : 0
      OpenStruct.new({user: User.find(user_id), to_do: user_not_completed, done: user_completed})
    end
  end
end
