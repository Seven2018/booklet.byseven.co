class TrainingsController < ApplicationController
  before_action :show_navbar_training
  skip_after_action :verify_policy_scoped

  def index
    @trainings = Training.where(company: current_user.company)
    @employees_form = User.where(company: current_user.company)
    @types_form = ["Synchronous", "Asynchronous"]

    @recommendations = UserInterest.where(user_id: current_user.id)

    unless current_user.hr_or_above?
      @trainings = @trainings.joins(sessions: :attendees).where(attendees: { user_id: current_user.id }).distinct
      @recommendations = @recommendations.where(user_id: current_user.id)
    end

    # SEARCH TRAININGS
    if params[:search_trainings].present?
      unless params[:search_trainings][:title].blank?
        @trainings = @trainings.search_trainings("#{params[:search_trainings][:title]}")
      end
      unless params[:training][:categories].reject{|c| c.empty?}.blank?
        @trainings = @trainings.joins(folder: :folder_categories).where(folder_categories: {category_id: params[:training][:categories].reject{|c| c.empty?}.map{|x| x.to_i}}) + @trainings.joins(sessions: {workshop: {content: :content_categories}}).where(content_categories: {category_id: params[:training][:categories].reject{|c| c.empty?}.map{|x| x.to_i}})
        @trainings = Training.where(id: @trainings.map{|x| x.id})
      end
      if params[:search_trainings][:period] == 'All'
        @trainings = @trainings
      elsif params[:search_trainings][:period] == 'Current'
        @trainings = @trainings.where_exists(:sessions, 'date >= ?', Date.today).or(@trainings.where_exists(:sessions, 'available_date >= ?', Date.today))
      elsif params[:search_trainings][:period] == 'Completed'
        @trainings = @trainings.where_not_exists(:sessions, 'date >= ?', Date.today).where_not_exists(:sessions, 'available_date >= ?', Date.today)
      end
      if current_user.hr_or_above?
        unless params[:search_trainings][:employee].blank?
          selected_employee = User.search_by_name("#{params[:search_trainings][:employee]}").first
          @trainings = @trainings.joins(sessions: :attendees).where(attendees: { user_id: selected_employee.id }).distinct
        end
      end
      unless params[:search_trainings][:type].blank?
        @trainings = @trainings.joins(sessions: :workshop).where(workshops: {content_type: params[:search_trainings][:type]})
      end
    end

    # SEARCHING RECOMMENDATIONS
    if params[:search_recommendations].present?
      unless params[:search_recommendations][:title].blank?
        @recommendations = @recommendations.search_recommendations("#{params[:search_recommendations][:title]}")
      end
      if current_user.hr_or_above?
        unless params[:search_recommendations][:employee].blank?
          selected_employee = User.find(params[:search_recommendations][:employee])
          @recommendations = UserInterest.where(user_id: selected_employee.id)
        end
      end
      unless params[:search_recommendations][:type].blank?
        @recommendations = @recommendations.joins(:content).where(contents: {content_type: params[:search_recommendations][:type]})
      end
    end

    @pending_recommendations = @recommendations.where(recommendation: "Pending")
    @accepted_recommendations = @recommendations.where(recommendation: "Yes")
    @declined_recommendations = @recommendations.where(recommendation: "No")
    @answered_recommendations = @accepted_recommendations + @declined_recommendations

    # @current_trainings = @trainings.joins(:sessions).where('date >= ?', Date.today).or(@trainings.joins(:sessions).where(sessions: {date: nil})).order(date: :desc).uniq.reverse
    # @current_trainings = @trainings.sort_by { |training| training.next_session }
    @current_trainings = @trainings.where_exists(:sessions, 'date >= ?', Date.today).or(@trainings.where_exists(:sessions, 'available_date >= ?', Date.today))
    @pasts_trainings = (@trainings - @current_trainings)

    respond_to do |format|
      format.html {trainings_path}
      format.js
    end
  end

  def my_trainings
    trainings = Training.joins(sessions: :attendees).where(attendees: {user: current_user}).distinct
    authorize trainings

    @future_trainings = trainings.select{|x| next_date == x.next_date.present?}
    # @past_trainings = trainings.select{|x| next_date == x.next_date.nil?}
  end

  def my_team_trainings
    attendees = Attendee.includes(session: :training).where(user_id: current_user.employees.ids).group_by(&:user_id)
    authorize attendees

    @future_trainings = attendees.each{|x,y| attendees[x] = y.map{|z| z.session.training if z.session.training.next_date.present?}.uniq}
    # @past_trainings = attendees.each{|x,y| attendees[x] = y.map{|z| z.session.training if z.session.training.next_date.nil?}.uniq}
  end

  def show
    @training = Training.find(params[:id])
    authorize @training
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

  def destroy
    @training = Training.find(params[:id])
    authorize @training
    @training.destroy
    redirect_to trainings_path
  end

  private

  def training_params
    params.require(:training).permit(:title, :folder_id, :auth_token)
  end
end
